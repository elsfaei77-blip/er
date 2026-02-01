#include "NotificationService.h"
#include <QDebug>
#include <QGuiApplication>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

NotificationService::NotificationService(QObject *parent) : QObject(parent) {
  m_trayIcon = new QSystemTrayIcon(this);
  m_trayIcon->setIcon(QIcon(
      ":/assets/app_icon.png")); // Ensure this icon exists or use fallback
  m_trayIcon->show();

  m_timer = new QTimer(this);
  connect(m_timer, &QTimer::timeout, this,
          &NotificationService::checkNotifications);
  m_timer->start(30000); // Check every 30s

  // Initial check after startup
  QTimer::singleShot(2000, this, &NotificationService::checkNotifications);
}

void NotificationService::checkNotifications() {
  if (m_userId == 0)
    return;

  // 1. Check Activity Notifications
  QString endpoint = QString("/api/notifications?user_id=%1").arg(m_userId);
  NetworkManager::instance().get(
      endpoint,
      [this](const QJsonDocument &doc) {
        if (doc.isArray()) {
          processNotifications(doc.array());
        }
      },
      [](QString error) {
        qWarning() << "Notification check failed:" << error;
      });
}

void NotificationService::processNotifications(const QJsonArray &arr) {
  int unread = 0;
  int maxId = m_lastMaxId;

  for (const QJsonValue &val : arr) {
    QJsonObject obj = val.toObject();
    bool isRead = obj["read"].toBool();
    int id = obj["id"].toInt();

    if (!isRead)
      unread++;

    // New notification detection
    if (id > m_lastMaxId &&
        m_lastMaxId > 0) { // Only toast if we have established a baseline
      QString type = obj["type"].toString();
      QString actor = obj["actor_name"].toString();
      QString msg;

      if (type == "like")
        msg = QString("%1 liked your post").arg(actor);
      else if (type == "follow")
        msg = QString("%1 started following you").arg(actor);
      else if (type == "reply")
        msg = QString("%1 replied to your post").arg(actor);
      else if (type == "message")
        msg = QString("%1 sent you a message").arg(actor);

      if (!msg.isEmpty()) {
        showSystemNotification("MIRA", msg);
      }
    }

    if (id > maxId)
      maxId = id;
  }

  if (m_lastMaxId == 0 && !arr.isEmpty()) {
    m_lastMaxId =
        arr[0].toObject()["id"].toInt(); // Initialize baseline without spamming
  } else {
    m_lastMaxId = maxId;
  }

  m_unreadCount = unread;
  emit unreadCountChanged();
}

void NotificationService::showSystemNotification(const QString &title,
                                                 const QString &message) {
  if (m_trayIcon) {
    m_trayIcon->showMessage(title, message, QSystemTrayIcon::Information, 3000);
  }
}
