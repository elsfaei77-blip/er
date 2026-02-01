#include "PostController.h"
#include "NotificationController.h"
#include <drogon/orm/DbClient.h>
#include <drogon/utils/Utilities.h>

void PostController::getFeed(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback) {
  auto userIdStr = req->getParameter("user_id");
  auto targetUserIdStr = req->getParameter("target_user_id");
  auto filter = req->getParameter("filter"); // "likes" or ""
  int userId = 0;
  int targetUserId = 0;

  try {
    if (!userIdStr.empty())
      userId = std::stoi(userIdStr);
    if (!targetUserIdStr.empty())
      targetUserId = std::stoi(targetUserIdStr);
  } catch (...) {
  }

  auto client = app().getDbClient();
  try {
    std::string sql;

    if (filter == "likes" && targetUserId > 0) {
      // Fetch posts LIKED by target user
      sql = "SELECT p.*, u.username, u.avatar, "
            "(SELECT COUNT(*) FROM likes WHERE post_id = p.id) as like_count, "
            "(SELECT COUNT(*) FROM comments WHERE post_id = p.id) as "
            "reply_count, "
            "(SELECT COUNT(*) FROM likes WHERE post_id = p.id AND user_id = ?) "
            "as is_liked, "
            "(SELECT type FROM likes WHERE post_id = p.id AND user_id = ?) as "
            "reaction_type, "
            "(SELECT group_concat(type || ':' || cnt) FROM (SELECT type, "
            "count(*) as cnt FROM likes WHERE post_id = p.id GROUP BY type)) "
            "as reaction_summary "
            "FROM posts p "
            "JOIN users u ON p.user_id = u.id "
            "JOIN likes l ON p.id = l.post_id "
            "WHERE l.user_id = ? "
            "ORDER BY l.timestamp DESC";
    } else {
      // Standard Feed logic (For You / Following / User Profile)
      sql = "SELECT p.*, u.username, u.avatar, "
            "(SELECT COUNT(*) FROM likes WHERE post_id = p.id) as like_count, "
            "(SELECT COUNT(*) FROM comments WHERE post_id = p.id) as "
            "reply_count, "
            "(SELECT COUNT(*) FROM likes WHERE post_id = p.id AND user_id = ?) "
            "as is_liked, "
            "(SELECT type FROM likes WHERE post_id = p.id AND user_id = ?) as "
            "reaction_type, "
            "'' as reaction_summary "
            "FROM posts p "
            "LEFT JOIN users u ON p.user_id = u.id ";

      if (targetUserId > 0) {
        // Specific user profile
        sql += "WHERE p.user_id = ? ";
      } else if (filter == "following") {
        // "Following" Feed
        sql += "WHERE p.user_id IN (SELECT followed_id FROM follows WHERE "
               "follower_id = ?) ";
      } else {
        // "For You" Feed (Default) - Show everything (Discovery)
        // In a real 'smart' algo, we'd order by score. For now, timestamp DESC.
        sql += "WHERE 1=1 ";
      }
      sql += "ORDER BY p.timestamp DESC LIMIT 50";
    }

    drogon::orm::Result result;
    if (filter == "likes" && targetUserId > 0) {
      result = client->execSqlSync(sql, userId, userId, targetUserId);
    } else if (targetUserId > 0) {
      result = client->execSqlSync(sql, userId, userId, targetUserId);
    } else if (filter == "following") {
      // Following feed needs userId param for the subquery
      result = client->execSqlSync(sql, userId, userId, userId);
    } else {
      // For You / Default
      result = client->execSqlSync(sql, userId, userId);
    }

    Json::Value posts(Json::arrayValue);
    for (auto row : result) {
      Json::Value p;
      p["id"] = row["id"].as<int>();
      p["user_id"] = row["user_id"].as<int>();
      p["username"] = !row["username"].isNull()
                          ? row["username"].as<std::string>()
                          : "User";
      p["avatar"] =
          !row["avatar"].isNull() ? row["avatar"].as<std::string>() : "";
      p["content"] =
          !row["content"].isNull() ? row["content"].as<std::string>() : "";
      p["media_url"] =
          !row["media_url"].isNull() ? row["media_url"].as<std::string>() : "";
      p["media_type"] = !row["media_type"].isNull()
                            ? row["media_type"].as<std::string>()
                            : "none";
      p["time"] =
          !row["timestamp"].isNull() ? row["timestamp"].as<std::string>() : "";
      p["likes"] =
          !row["like_count"].isNull() ? row["like_count"].as<int>() : 0;
      p["replies"] =
          !row["reply_count"].isNull() ? row["reply_count"].as<int>() : 0;
      p["liked_by_me"] =
          (!row["is_liked"].isNull() && row["is_liked"].as<int>() > 0);

      try {
        if (!row["reaction_type"].isNull())
          p["reaction_type"] = row["reaction_type"].as<std::string>();
        else
          p["reaction_type"] = "";

        if (!row["reaction_summary"].isNull())
          p["reaction_summary"] = row["reaction_summary"].as<std::string>();
        else
          p["reaction_summary"] = "";
      } catch (...) {
        p["reaction_type"] = "";
        p["reaction_summary"] = "";
      }
      posts.append(p);
    }
    callback(HttpResponse::newHttpJsonResponse(posts));

  } catch (const std::exception &e) {
    LOG_ERROR << e.what();
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k500InternalServerError);
    callback(resp);
  }
}

void PostController::createPost(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback) {
  auto json = req->getJsonObject();
  if (!json) {
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k400BadRequest);
    callback(resp);
    return;
  }

  auto userId = (*json)["user_id"].asInt();
  auto content = (*json)["content"].asString();
  if (content.length() > 10000) { // HARDENED: Limit post size
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k400BadRequest);
    resp->setBody("Content too long");
    callback(resp);
    return;
  }
  auto mediaUrl = (*json)["media_url"].asString();
  auto mediaType = (*json)["media_type"].asString();
  std::string postType = "post";
  if ((*json).isMember("post_type"))
    postType = (*json)["post_type"].asString();

  if (mediaType.empty())
    mediaType = "none";

  std::string token = req->getHeader("Authorization");
  if (token.empty() || token != std::to_string(userId)) {
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k401Unauthorized);
    resp->setBody("Unauthorized");
    callback(resp);
    return;
  }

  // Insert
  auto client = app().getDbClient();
  try {
    client->execSqlSync("INSERT INTO posts (user_id, content, media_url, "
                        "media_type, post_type) VALUES (?, ?, ?, ?, ?)",
                        userId, content, mediaUrl, mediaType, postType);

    Json::Value ret;
    ret["status"] = "success";
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void PostController::toggleLike(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int postId) {
  // Delegate to react() to avoid code duplication
  // Construct a logical request to pass to react
  // Or simpler: Extract common logic.
  // For now, client calls both. Let's make toggleLike just call separate
  // internal logic or just reuse react logic. Actually, toggleLike checks for
  // existence and toggles. React checks for existence and toggles IF same type,
  // updates if different. 'react' with type='like' IS 'toggleLike'.

  react(req, std::move(callback), postId);
}

void PostController::react(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int postId) {
  auto json = req->getJsonObject();
  int userId = 0;
  std::string type = "like";
  if (json) {
    userId = (*json)["user_id"].asInt();
    if ((*json).isMember("type"))
      type = (*json)["type"].asString();
  }

  std::string token = req->getHeader("Authorization");
  if (token.empty() || token != std::to_string(userId)) {
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k401Unauthorized);
    callback(resp);
    return;
  }

  auto client = app().getDbClient();
  try {
    // Check if exists
    auto res = client->execSqlSync(
        "SELECT * FROM likes WHERE user_id = ? AND post_id = ?", userId,
        postId);

    std::string action;
    if (!res.empty()) {
      std::string currentType = res[0]["type"].as<std::string>();
      if (currentType == type) {
        // Remove if same type (toggle off)
        client->execSqlSync(
            "DELETE FROM likes WHERE user_id = ? AND post_id = ?", userId,
            postId);
        action = "unreacted";
      } else {
        // Update type
        client->execSqlSync(
            "UPDATE likes SET type = ? WHERE user_id = ? AND post_id = ?", type,
            userId, postId);
        action = "updated";
      }
    } else {
      client->execSqlSync(
          "INSERT INTO likes (user_id, post_id, type) VALUES (?, ?, ?)", userId,
          postId, type);
      action = "reacted";
    }
    // Get updated summary
    auto summaryRes = client->execSqlSync(
        "SELECT group_concat(type || ':' || cnt) as summary FROM "
        "(SELECT type, count(*) as cnt FROM likes WHERE post_id = ? GROUP BY "
        "type)",
        postId);

    std::string summary = "";
    if (!summaryRes.empty() && !summaryRes[0]["summary"].isNull())
      summary = summaryRes[0]["summary"].as<std::string>();

    Json::Value ret;
    ret["status"] = "success";
    ret["action"] = action;
    ret["reaction_summary"] = summary;
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (const std::exception &e) {
    LOG_ERROR << e.what();
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void PostController::uploadFile(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback) {
  drogon::MultiPartParser parser;
  if (parser.parse(req) != 0 || parser.getFiles().empty()) {
    Json::Value ret;
    ret["error"] = "No file";
    auto resp = HttpResponse::newHttpJsonResponse(ret);
    resp->setStatusCode(k400BadRequest);
    callback(resp);
    return;
  }

  auto &file = parser.getFiles()[0];
  auto ext = file.getFileExtension();
  auto uuid = drogon::utils::getUuid();
  std::string filename = uuid + "." + std::string(ext);

  // Save
  file.saveAs(filename);

  // Construct URL
  // Hardened: Do not trust "Host" header blindly for permanent storage
  // references if possible. Ideally use a config value. For now, we sanitize or
  // fallback safer. But for local dev, keeping dynamic host is useful. Let's at
  // least ensure we don't blindly accept weird chars. Better yet, for a local
  // app, hardcoding the known port or using a relative path that the client
  // resolves is better. Current client logic expects full URL. We will stick to
  // the IP/Port the server *knows* it's listening on, or the request's local
  // address? req->getLocalAddr() returns InetAddr. Let's use a safe default if
  // Host is suspicious, but for now we'll trust it BUT enforce the uploads
  // directory context.

  std::string host = req->getHeader("Host");
  if (host.empty())
    host = "127.0.0.1:8000";

  std::string url = "http://" + host + "/uploads/" + filename;

  std::string ptype = "image";
  if (ext == "mp4" || ext == "mov" || ext == "avi")
    ptype = "video";

  Json::Value ret;
  ret["url"] = url;
  ret["type"] = ptype;
  callback(HttpResponse::newHttpJsonResponse(ret));
}

void PostController::getComments(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int postId) {
  auto client = app().getDbClient();
  try {
    auto res = client->execSqlSync("SELECT c.*, u.username, u.avatar "
                                   "FROM comments c "
                                   "JOIN users u ON c.user_id = u.id "
                                   "WHERE c.post_id = ? "
                                   "ORDER BY c.timestamp ASC",
                                   postId);

    Json::Value arr(Json::arrayValue);
    for (auto r : res) {
      Json::Value c;
      c["id"] = r["id"].as<int>();
      c["post_id"] = r["post_id"].as<int>();
      c["username"] = r["username"].as<std::string>();
      c["avatar"] = r["avatar"].as<std::string>();
      c["content"] = r["content"].as<std::string>();
      c["timestamp"] = r["timestamp"].as<std::string>();
      arr.append(c);
    }
    callback(HttpResponse::newHttpJsonResponse(arr));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}
// } removed

void PostController::getStories(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback) {
  int userId = 0;
  try {
    userId = std::stoi(req->getParameter("user_id"));
  } catch (...) {
  }

  auto client = app().getDbClient();
  try {
    std::string sql = "SELECT p.*, u.username, u.avatar, "
                      "(SELECT 1 FROM follows WHERE follower_id = ? AND "
                      "followed_id = u.id) as is_following "
                      "FROM posts p "
                      "JOIN users u ON p.user_id = u.id "
                      "WHERE p.post_type = 'story' "
                      "AND p.timestamp > datetime('now', '-1 day') ";

    if (userId > 0) {
      sql += "AND p.user_id NOT IN (SELECT blocked_id FROM blocks WHERE "
             "blocker_id = ?) ";
    }

    sql += "ORDER BY p.timestamp ASC";

    drogon::orm::Result result;
    if (userId > 0) {
      result = client->execSqlSync(sql, userId, userId);
    } else {
      result = client->execSqlSync(sql);
    }

    Json::Value stories(Json::arrayValue);
    for (auto row : result) {
      Json::Value s;
      s["id"] = row["id"].as<int>();
      s["user_id"] = row["user_id"].as<int>();
      s["username"] = row["username"].as<std::string>();
      s["avatar"] = row["avatar"].as<std::string>();
      s["media_url"] = row["media_url"].as<std::string>();
      s["media_type"] =
          row["media_type"].as<std::string>(); // 'image' or 'video'
      s["timestamp"] = row["timestamp"].as<std::string>();
      s["is_following"] = row["is_following"].as<int>() > 0;
      stories.append(s);
    }
    callback(HttpResponse::newHttpJsonResponse(stories));
  } catch (const std::exception &e) {
    LOG_ERROR << e.what();
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void PostController::addComment(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int postId) {
  auto json = req->getJsonObject();
  if (!json) {
    callback(HttpResponse::newHttpResponse(k400BadRequest, CT_NONE));
    return;
  }

  int userId = (*json)["user_id"].asInt();
  std::string content = (*json)["content"].asString();

  std::string token = req->getHeader("Authorization");
  if (token.empty() || token != std::to_string(userId)) {
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k401Unauthorized);
    callback(resp);
    return;
  }

  auto client = app().getDbClient();
  try {
    client->execSqlSync(
        "INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)",
        postId, userId, content);
    // Notif logic
    auto p =
        client->execSqlSync("SELECT user_id FROM posts WHERE id = ?", postId);
    if (!p.empty()) {
      int ownerId = p[0]["user_id"].as<int>();
      NotificationController::createNotification(ownerId, userId, "reply",
                                                 postId);
    }

    Json::Value ret;
    ret["status"] = "success";
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void PostController::editPost(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int postId) {
  auto json = req->getJsonObject();
  if (!json || !json->isMember("user_id") || !json->isMember("content")) {
    callback(HttpResponse::newHttpResponse(k400BadRequest, CT_NONE));
    return;
  }

  int userId = (*json)["user_id"].asInt();
  std::string content = (*json)["content"].asString();

  std::string token = req->getHeader("Authorization");
  if (token.empty() || token != std::to_string(userId)) {
    callback(HttpResponse::newHttpResponse(k401Unauthorized, CT_NONE));
    return;
  }

  auto client = app().getDbClient();
  try {
    // Verify owner
    auto res =
        client->execSqlSync("SELECT user_id FROM posts WHERE id = ?", postId);
    if (res.empty() || res[0]["user_id"].as<int>() != userId) {
      callback(HttpResponse::newHttpResponse(k401Unauthorized, CT_NONE));
      return;
    }

    client->execSqlSync("UPDATE posts SET content = ? WHERE id = ?", content,
                        postId);

    Json::Value ret;
    ret["status"] = "success";
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void PostController::deletePost(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int postId) {
  auto json = req->getJsonObject();
  if (!json || !json->isMember("user_id")) {
    callback(HttpResponse::newHttpResponse(k400BadRequest, CT_NONE));
    return;
  }

  int userId = (*json)["user_id"].asInt();

  std::string token = req->getHeader("Authorization");
  if (token.empty() || token != std::to_string(userId)) {
    callback(HttpResponse::newHttpResponse(k401Unauthorized, CT_NONE));
    return;
  }

  auto client = app().getDbClient();
  try {
    // Verify owner
    auto res =
        client->execSqlSync("SELECT user_id FROM posts WHERE id = ?", postId);
    if (res.empty() || res[0]["user_id"].as<int>() != userId) {
      callback(HttpResponse::newHttpResponse(k401Unauthorized, CT_NONE));
      return;
    }

    // Delete post and related data
    client->execSqlSync("DELETE FROM likes WHERE post_id = ?", postId);
    client->execSqlSync("DELETE FROM comments WHERE post_id = ?", postId);
    client->execSqlSync("DELETE FROM posts WHERE id = ?", postId);

    Json::Value ret;
    ret["status"] = "success";
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void PostController::deleteStory(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int postId) {
  // Stories are posts with type='story', so we can reuse deletePost logic
  // mostly But maybe we want to delete the file from disk if it's a story (or
  // post too)
  deletePost(req, std::move(callback), postId);
}
