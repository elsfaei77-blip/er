#include "NotificationModel.h"
#include "NetworkManager.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>

NotificationModel::NotificationModel(QObject *parent)
    : QAbstractListModel(parent) {}

int NotificationModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid())
    return 0;
  return m_notifications.size();
}

QVariant NotificationModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_notifications.size())
    return QVariant();

  const Notification &n = m_notifications[index.row()];
  switch (role) {
  case IdRole:
    return n.id;
  case TypeRole:
    return n.type;
  case ActorNameRole:
    return n.actorName;
  case ActorAvatarRole:
    return n.actorAvatar;
  case PostIdRole:
    return n.postId;
  case TimeRole:
    return n.timestamp;
  case ReadRole:
    return n.read;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> NotificationModel::roleNames() const {
  return {{IdRole, "id"},
          {TypeRole, "type"},
          {ActorNameRole, "actorName"},
          {ActorAvatarRole, "actorAvatar"},
          {PostIdRole, "postId"},
          {TimeRole, "time"},
          {ReadRole, "isRead"}};
}

void NotificationModel::setUserId(int id) {
  if (m_userId != id) {
    m_userId = id;
    emit userIdChanged();
    refresh();
  }
}

void NotificationModel::refresh() {
  if (m_userId == 0)
    return;

  QString endpoint = QString("/api/notifications?user_id=%1").arg(m_userId);
  NetworkManager::instance().get(
      endpoint,
      [this](const QJsonDocument &doc) {
        beginResetModel();
        m_notifications.clear();

        if (doc.isArray()) {
          QJsonArray arr = doc.array();
          for (const QJsonValue &val : arr) {
            QJsonObject obj = val.toObject();
            Notification n;
            n.id = obj["id"].toInt();
            n.type = obj["type"].toString();
            n.actorName = obj["actor_name"].toString();
            n.actorAvatar = obj["actor_avatar"].toString();
            if (obj.contains("post_id"))
              n.postId = obj["post_id"].toInt();
            else
              n.postId = 0;
            n.timestamp = obj["timestamp"].toString();
            n.read = obj["read"].toBool();
            m_notifications.append(n);
          }
        }
        endResetModel();
        qDebug() << "Notifications loaded:" << m_notifications.size();
      },
      [](QString err) {
        qWarning() << "Failed to load notifications:" << err;
      });
}
