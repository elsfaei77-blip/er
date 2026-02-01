#pragma once
#include <drogon/HttpController.h>

using namespace drogon;

class NotificationController
    : public drogon::HttpController<NotificationController> {
public:
  METHOD_LIST_BEGIN
  ADD_METHOD_TO(NotificationController::getNotifications, "/api/notifications",
                Get);
  METHOD_LIST_END

  void
  getNotifications(const HttpRequestPtr &req,
                   std::function<void(const HttpResponsePtr &)> &&callback);

  // Static helper to create notifications from other controllers
  static void createNotification(int userId, int actorId,
                                 const std::string &type, int postId = 0);
};
