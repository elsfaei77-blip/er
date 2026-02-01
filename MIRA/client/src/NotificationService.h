#pragma once
#include "NetworkManager.h"
#include <QObject>
#include <QSystemTrayIcon>
#include <QTimer>

class NotificationService : public QObject {
  Q_OBJECT
  Q_PROPERTY(int unreadCount READ unreadCount NOTIFY unreadCountChanged)

public:
  explicit NotificationService(QObject *parent = nullptr);
  int unreadCount() const { return m_unreadCount; }

  Q_INVOKABLE void checkNotifications();
  Q_INVOKABLE void showSystemNotification(const QString &title,
                                          const QString &message);
  void setUserId(int id) { m_userId = id; }

signals:
  void unreadCountChanged();

private:
  QSystemTrayIcon *m_trayIcon;
  QTimer *m_timer;
  int m_unreadCount = 0;
  int m_lastMaxId =
      0; // Track last seen notification ID to avoid repeating toasts
  int m_userId = 0;

  void processNotifications(const QJsonArray &arr);
};
