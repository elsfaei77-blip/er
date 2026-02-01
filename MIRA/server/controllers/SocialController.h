#pragma once
#include <drogon/HttpController.h>

using namespace drogon;

class SocialController : public drogon::HttpController<SocialController> {
public:
  METHOD_LIST_BEGIN
  ADD_METHOD_TO(SocialController::followUser, "/api/follow/{1}", Post);
  // METHOD_LIST_END // Note: messages could go here but for now following user
  // instruction on "Social" I will add Messages here as well to complete
  // "Social"
  ADD_METHOD_TO(SocialController::getConversations, "/api/conversations", Get);
  ADD_METHOD_TO(SocialController::getMessages, "/api/messages/{1}", Get);
  ADD_METHOD_TO(SocialController::sendMessage, "/api/messages/{1}", Post);
  ADD_METHOD_TO(SocialController::editMessage, "/api/messages/{1}", Put);
  ADD_METHOD_TO(SocialController::deleteMessage, "/api/messages/{1}", Delete);
  ADD_METHOD_TO(SocialController::deleteConversation, "/api/conversations/{1}",
                Delete);
  ADD_METHOD_TO(SocialController::blockUser, "/api/block/{1}", Post);
  METHOD_LIST_END

  void followUser(const HttpRequestPtr &req,
                  std::function<void(const HttpResponsePtr &)> &&callback,
                  int targetId);
  void
  getConversations(const HttpRequestPtr &req,
                   std::function<void(const HttpResponsePtr &)> &&callback);
  void getMessages(const HttpRequestPtr &req,
                   std::function<void(const HttpResponsePtr &)> &&callback,
                   int partnerId);
  void sendMessage(const HttpRequestPtr &req,
                   std::function<void(const HttpResponsePtr &)> &&callback,
                   int partnerId);
  void editMessage(const HttpRequestPtr &req,
                   std::function<void(const HttpResponsePtr &)> &&callback,
                   int messageId);
  void deleteMessage(const HttpRequestPtr &req,
                     std::function<void(const HttpResponsePtr &)> &&callback,
                     int messageId);
  void
  deleteConversation(const HttpRequestPtr &req,
                     std::function<void(const HttpResponsePtr &)> &&callback,
                     int partnerId);
  void blockUser(const HttpRequestPtr &req,
                 std::function<void(const HttpResponsePtr &)> &&callback,
                 int targetId);
};
