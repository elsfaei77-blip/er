#include "SocialController.h"
#include "NotificationController.h"
#include <drogon/orm/DbClient.h>

void SocialController::followUser(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int targetId) {
  auto json = req->getJsonObject();
  if (!json) {
    callback(HttpResponse::newHttpResponse(k400BadRequest, CT_NONE));
    return;
  }

  int actorId = (*json)["user_id"].asInt();

  auto client = app().getDbClient();
  try {
    auto check = client->execSqlSync(
        "SELECT 1 FROM follows WHERE follower_id = ? AND followed_id = ?",
        actorId, targetId);
    std::string action;
    if (!check.empty()) {
      client->execSqlSync(
          "DELETE FROM follows WHERE follower_id = ? AND followed_id = ?",
          actorId, targetId);
      action = "unfollowed";
    } else {
      client->execSqlSync(
          "INSERT INTO follows (follower_id, followed_id) VALUES (?, ?)",
          actorId, targetId);
      action = "followed";

      // Send Notification
      NotificationController::createNotification(targetId, actorId, "follow");
    }

    Json::Value ret;
    ret["status"] = "success";
    ret["action"] = action;
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void SocialController::getConversations(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback) {
  int userId = 0;
  try {
    userId = std::stoi(req->getParameter("user_id"));
  } catch (...) {
  }

  auto client = app().getDbClient();
  try {
    // Complex query simplified: Get distinct partners
    auto partners = client->execSqlSync(
        "SELECT DISTINCT CASE WHEN sender_id = ? THEN receiver_id ELSE "
        "sender_id END as partner_id "
        "FROM messages WHERE sender_id = ? OR receiver_id = ?",
        userId, userId, userId);

    Json::Value results(Json::arrayValue);
    for (auto p : partners) {
      int pid = p["partner_id"].as<int>();
      auto u = client->execSqlSync(
          "SELECT username, avatar FROM users WHERE id = ?", pid);
      if (u.empty())
        continue;

      auto lastMsg =
          client->execSqlSync("SELECT content, timestamp, read FROM messages "
                              "WHERE (sender_id = ? AND receiver_id = ?) OR "
                              "(sender_id = ? AND receiver_id = ?) "
                              "ORDER BY timestamp DESC LIMIT 1",
                              userId, pid, pid, userId);

      if (!lastMsg.empty()) {
        Json::Value item;
        item["partner_id"] = pid;
        item["username"] = u[0]["username"].as<std::string>();
        item["avatar"] = u[0]["avatar"].as<std::string>();
        item["last_message"] = lastMsg[0]["content"].as<std::string>();
        item["timestamp"] = lastMsg[0]["timestamp"].as<std::string>();
        item["read"] = (bool)lastMsg[0]["read"].as<int>();
        results.append(item);
      }
    }
    callback(HttpResponse::newHttpJsonResponse(results));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void SocialController::getMessages(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int partnerId) {
  int userId = 0;
  try {
    userId = std::stoi(req->getParameter("user_id"));
  } catch (...) {
  }

  auto client = app().getDbClient();
  try {
    auto msgs = client->execSqlSync("SELECT * FROM messages "
                                    "WHERE (sender_id = ? AND receiver_id = ?) "
                                    "OR (sender_id = ? AND receiver_id = ?) "
                                    "ORDER BY timestamp ASC",
                                    userId, partnerId, partnerId, userId);

    Json::Value res(Json::arrayValue);
    for (auto m : msgs) {
      Json::Value item;
      item["id"] = m["id"].as<int>();
      item["sender_id"] = m["sender_id"].as<int>();
      item["content"] = m["content"].as<std::string>();
      item["media_url"] = m["media_url"].as<std::string>();
      item["timestamp"] = m["timestamp"].as<std::string>();
      item["is_me"] = (m["sender_id"].as<int>() == userId);
      res.append(item);
    }
    callback(HttpResponse::newHttpJsonResponse(res));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void SocialController::sendMessage(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int partnerId) {
  auto json = req->getJsonObject();
  if (!json) {
    callback(HttpResponse::newHttpResponse(k400BadRequest, CT_NONE));
    return;
  }

  int userId = (*json)["user_id"].asInt();
  std::string content = (*json)["content"].asString();
  std::string mediaUrl = (*json)["media_url"].asString();

  auto client = app().getDbClient();
  try {
    client->execSqlSync("INSERT INTO messages (sender_id, receiver_id, "
                        "content, media_url) VALUES (?, ?, ?, ?)",
                        userId, partnerId, content, mediaUrl);

    // Create notification for new message
    NotificationController::createNotification(partnerId, userId, "message");

    Json::Value ret;
    ret["status"] = "success";
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void SocialController::editMessage(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int messageId) {
  auto json = req->getJsonObject();
  if (!json || !json->isMember("user_id") || !json->isMember("content")) {
    callback(HttpResponse::newHttpResponse(k400BadRequest, CT_NONE));
    return;
  }

  int userId = (*json)["user_id"].asInt();
  std::string content = (*json)["content"].asString();

  auto client = app().getDbClient();
  try {
    // Verify sender
    auto res = client->execSqlSync(
        "SELECT sender_id FROM messages WHERE id = ?", messageId);
    if (res.empty() || res[0]["sender_id"].as<int>() != userId) {
      callback(HttpResponse::newHttpResponse(k401Unauthorized, CT_NONE));
      return;
    }

    client->execSqlSync("UPDATE messages SET content = ? WHERE id = ?", content,
                        messageId);

    Json::Value ret;
    ret["status"] = "success";
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void SocialController::deleteMessage(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int messageId) {
  auto json = req->getJsonObject();
  if (!json || !json->isMember("user_id")) {
    callback(HttpResponse::newHttpResponse(k400BadRequest, CT_NONE));
    return;
  }

  int userId = (*json)["user_id"].asInt();

  auto client = app().getDbClient();
  try {
    // Verify sender
    auto res = client->execSqlSync(
        "SELECT sender_id FROM messages WHERE id = ?", messageId);
    if (res.empty() || res[0]["sender_id"].as<int>() != userId) {
      callback(HttpResponse::newHttpResponse(k401Unauthorized, CT_NONE));
      return;
    }

    client->execSqlSync("DELETE FROM messages WHERE id = ?", messageId);

    Json::Value ret;
    ret["status"] = "success";
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void SocialController::deleteConversation(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int partnerId) {
  int userId = 0;
  try {
    userId = std::stoi(req->getParameter("user_id"));
  } catch (...) {
  }

  auto client = app().getDbClient();
  try {
    client->execSqlSync(
        "DELETE FROM messages WHERE (sender_id = ? AND receiver_id = ?) OR "
        "(sender_id = ? AND receiver_id = ?)",
        userId, partnerId, partnerId, userId);

    Json::Value ret;
    ret["status"] = "success";
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void SocialController::blockUser(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback, int targetId) {
  auto json = req->getJsonObject();
  if (!json || !json->isMember("user_id")) {
    callback(HttpResponse::newHttpResponse(k400BadRequest, CT_NONE));
    return;
  }

  int userId = (*json)["user_id"].asInt();

  auto client = app().getDbClient();
  try {
    // Check if already blocked
    auto check = client->execSqlSync(
        "SELECT 1 FROM blocks WHERE blocker_id = ? AND blocked_id = ?", userId,
        targetId);
    std::string action;
    if (check.empty()) {
      client->execSqlSync(
          "INSERT INTO blocks (blocker_id, blocked_id) VALUES (?, ?)", userId,
          targetId);
      action = "blocked";
    } else {
      client->execSqlSync(
          "DELETE FROM blocks WHERE blocker_id = ? AND blocked_id = ?", userId,
          targetId);
      action = "unblocked";
    }

    Json::Value ret;
    ret["status"] = "success";
    ret["action"] = action;
    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (...) {
    // Blocks table might not exist, I should ensure it exists or create it
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}
