#pragma once
#include <drogon/HttpController.h>

using namespace drogon;

class PostController : public drogon::HttpController<PostController> {
public:
  METHOD_LIST_BEGIN
  ADD_METHOD_TO(PostController::getFeed, "/api/feed", Get);
  ADD_METHOD_TO(PostController::createPost, "/api/post", Post);
  ADD_METHOD_TO(PostController::toggleLike, "/api/post/{1}/like", Post);
  ADD_METHOD_TO(PostController::react, "/api/post/{1}/react", Post); // New
  ADD_METHOD_TO(PostController::uploadFile, "/api/upload", Post);
  ADD_METHOD_TO(PostController::getComments, "/api/post/{1}/comments", Get);
  ADD_METHOD_TO(PostController::getStories, "/api/stories", Get); // New
  ADD_METHOD_TO(PostController::editPost, "/api/post/{1}", Put);
  ADD_METHOD_TO(PostController::deletePost, "/api/post/{1}", Delete);
  ADD_METHOD_TO(PostController::deleteStory, "/api/story/{1}", Delete);
  ADD_METHOD_TO(PostController::addComment, "/api/post/{1}/comment", Post);
  METHOD_LIST_END

  void getFeed(const HttpRequestPtr &req,
               std::function<void(const HttpResponsePtr &)> &&callback);
  void createPost(const HttpRequestPtr &req,
                  std::function<void(const HttpResponsePtr &)> &&callback);
  void toggleLike(const HttpRequestPtr &req,
                  std::function<void(const HttpResponsePtr &)> &&callback,
                  int postId);
  void react(const HttpRequestPtr &req,
             std::function<void(const HttpResponsePtr &)> &&callback,
             int postId);
  void uploadFile(const HttpRequestPtr &req,
                  std::function<void(const HttpResponsePtr &)> &&callback);
  void getComments(const HttpRequestPtr &req,
                   std::function<void(const HttpResponsePtr &)> &&callback,
                   int postId);
  void getStories(const HttpRequestPtr &req,
                  std::function<void(const HttpResponsePtr &)> &&callback);
  void addComment(const HttpRequestPtr &req,
                  std::function<void(const HttpResponsePtr &)> &&callback,
                  int postId);
  void editPost(const HttpRequestPtr &req,
                std::function<void(const HttpResponsePtr &)> &&callback,
                int postId);
  void deletePost(const HttpRequestPtr &req,
                  std::function<void(const HttpResponsePtr &)> &&callback,
                  int postId);
  void deleteStory(const HttpRequestPtr &req,
                   std::function<void(const HttpResponsePtr &)> &&callback,
                   int postId);
};
