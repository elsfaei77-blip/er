#include "src/AuthService.h"
// #include "src/DatabaseManager.h" // Removed
#include "src/AIService.h"
#include "src/CommentModel.h"
#include "src/ConversationModel.h"
#include "src/HapticManager.h"
#include "src/MessageModel.h"
#include "src/NotificationModel.h"
#include "src/NotificationService.h"
#include "src/ProfileViewModel.h"
#include "src/SearchViewModel.h"
#include "src/ThreadModel.h"
#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>

#include <QQuickStyle>

#include <QApplication>

int main(int argc, char *argv[]) {
  QQuickStyle::setStyle("Basic");
  QApplication app(argc, argv);

  qmlRegisterType<ProfileViewModel>("MiraApp", 1, 0, "ProfileViewModel");
  qmlRegisterType<ThreadModel>("MiraApp", 1, 0, "ThreadModel");
  qmlRegisterType<SearchViewModel>("MiraApp", 1, 0, "SearchViewModel");
  qmlRegisterType<ConversationModel>("MiraApp", 1, 0, "ConversationModel");
  qmlRegisterType<CommentModel>("MiraApp", 1, 0, "CommentModel");
  qmlRegisterType<MessageModel>("MiraApp", 1, 0, "MessageModel");
  qmlRegisterType<NotificationModel>("MiraApp", 1, 0, "NotificationModel");
  qmlRegisterType<AIService>("MiraApp", 1, 0, "AIService");

  // DatabaseManager Removed - Client relies on Server API

  AuthService authService;

  QQmlApplicationEngine engine;
  engine.addImportPath("qrc:/");
  HapticManager hapticManager;
  engine.rootContext()->setContextProperty("HapticManager", &hapticManager);
  engine.rootContext()->setContextProperty("authService", &authService);

  NotificationService notifService;
  engine.rootContext()->setContextProperty("notificationService",
                                           &notifService);

  QObject::connect(&authService, &AuthService::loginSuccess,
                   [&notifService, &authService]() {
                     int uid = authService.currentUser().value("id").toInt();
                     notifService.setUserId(uid);
                     notifService.checkNotifications();
                   });

  // Also check if already logged in (if caching implemented in AuthService)
  if (authService.isAuthenticated()) {
    notifService.setUserId(authService.currentUser().value("id").toInt());
    notifService.checkNotifications();
  }

  const QUrl url(QStringLiteral("qrc:/main.qml"));
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreated, &app,
      [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
          QCoreApplication::exit(-1);
      },
      Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}
