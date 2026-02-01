#pragma once
#include <drogon/HttpController.h>

using namespace drogon;

class UserController : public drogon::HttpController<UserController> {
public:
  METHOD_LIST_BEGIN
  ADD_METHOD_TO(UserController::getProfile, "/api/user/{1}/profile", Get);
  ADD_METHOD_TO(UserController::updateProfile, "/api/profile/update", Post);
  ADD_METHOD_TO(UserController::getNotifications, "/api/notifications", Get);
  ADD_METHOD_TO(UserController::search, "/api/search", Get);
  ADD_METHOD_TO(UserController::deleteAccount, "/api/user/delete", Post);
  ADD_METHOD_TO(UserController::googleLogin, "/api/auth/google", Post);
  ADD_METHOD_TO(UserController::sendVerificationCode, "/api/auth/send-code",
                Post); // New
  METHOD_LIST_END

  void getProfile(const HttpRequestPtr &req,
                  std::function<void(const HttpResponsePtr &)> &&callback,
                  int userId);
  void updateProfile(const HttpRequestPtr &req,
                     std::function<void(const HttpResponsePtr &)> &&callback);
  void
  getNotifications(const HttpRequestPtr &req,
                   std::function<void(const HttpResponsePtr &)> &&callback);
  void search(const HttpRequestPtr &req,
              std::function<void(const HttpResponsePtr &)> &&callback);
  void deleteAccount(const HttpRequestPtr &req,
                     std::function<void(const HttpResponsePtr &)> &&callback);
  void googleLogin(const HttpRequestPtr &req,
                   std::function<void(const HttpResponsePtr &)> &&callback);
  void sendVerificationCode(
      const HttpRequestPtr &req,
      std::function<void(const HttpResponsePtr &)> &&callback); // New
};
