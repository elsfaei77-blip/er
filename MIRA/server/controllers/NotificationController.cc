#include "NotificationController.h"
#include <drogon/orm/DbClient.h>

void NotificationController::getNotifications(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback) {
  int userId = 0;
  try {
    userId = std::stoi(req->getParameter("user_id"));
  } catch (...) {
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
    auto res = client->execSqlSync(
        "SELECT n.*, u.username, u.avatar FROM notifications n "
        "JOIN users u ON n.actor_id = u.id "
        "WHERE n.user_id = ? ORDER BY n.timestamp DESC",
        userId);
    Json::Value arr(Json::arrayValue);
    for (auto r : res) {
      Json::Value n;
      n["id"] = r["id"].as<int>();
      n["type"] = r["type"].as<std::string>();
      n["actor_name"] = r["username"].as<std::string>();
      n["actor_avatar"] = r["avatar"].as<std::string>();
      if (!r["post_id"].isNull())
        n["post_id"] = r["post_id"].as<int>();
      n["timestamp"] = r["timestamp"].as<std::string>();
      n["read"] = (bool)r["read"].as<int>();
      arr.append(n);
    }
    callback(HttpResponse::newHttpJsonResponse(arr));
  } catch (const std::exception &e) {
    LOG_ERROR << e.what();
    callback(HttpResponse::newHttpResponse(k500InternalServerError, CT_NONE));
  }
}

void NotificationController::createNotification(int userId, int actorId,
                                                const std::string &type,
                                                int postId) {
  // if (userId == actorId) return; // Allow self-notif for testing
  LOG_INFO << "Creating notification: Typ=" << type << " User=" << userId
           << " Actor=" << actorId;

  auto client = app().getDbClient();
  try {
    // Prevent duplicate notifications for likes/follows
    if (type == "like" || type == "follow") {
      std::string sql = "SELECT id FROM notifications WHERE user_id = ? AND "
                        "actor_id = ? AND type = ?";
      if (postId > 0)
        sql += " AND post_id = ?";

      drogon::orm::Result check;
      if (postId > 0)
        check = client->execSqlSync(sql, userId, actorId, type, postId);
      else
        check = client->execSqlSync(sql, userId, actorId, type);

      if (!check.empty())
        return; // Already exists
    }

    // Insert
    if (postId > 0) {
      client->execSqlSync("INSERT INTO notifications (user_id, actor_id, type, "
                          "post_id) VALUES (?, ?, ?, ?)",
                          userId, actorId, type, postId);
    } else {
      client->execSqlSync("INSERT INTO notifications (user_id, actor_id, type) "
                          "VALUES (?, ?, ?)",
                          userId, actorId, type);
    }
  } catch (const std::exception &e) {
    LOG_ERROR << "Failed to create notification: " << e.what();
  }
}
