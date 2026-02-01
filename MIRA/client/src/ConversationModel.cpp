#include "ConversationModel.h"
#include "NetworkManager.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

ConversationModel::ConversationModel(QObject *parent)
    : QAbstractListModel(parent) {
  // refresh();
}

int ConversationModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid())
    return 0;
  return m_conversations.size();
}

QVariant ConversationModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_conversations.size())
    return QVariant();

  const Conversation &c = m_conversations[index.row()];
  switch (role) {
  case PartnerIdRole:
    return c.partnerId;
  case UsernameRole:
    return c.username;
  case AvatarColorRole:
    return c.avatarColor;
  case LastMsgRole:
    return c.lastMsg;
  case TimeRole:
    return c.time;
  case UnreadRole:
    return c.unread;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> ConversationModel::roleNames() const {
  return {{PartnerIdRole, "partnerId"},
          {UsernameRole, "username"},
          {AvatarColorRole, "avatarColor"},
          {LastMsgRole, "lastMsg"},
          {TimeRole, "time"},
          {UnreadRole, "unread"}};
}

void ConversationModel::refresh() {
  QString userId = NetworkManager::instance().getToken();
  if (userId.isEmpty())
    userId = "1"; // Debug

  QString endpoint = QString("/api/conversations?user_id=%1").arg(userId);

  NetworkManager::instance().get(
      endpoint,
      [this](const QJsonDocument &doc) {
        beginResetModel();
        m_conversations.clear();

        QJsonArray arr;
        if (doc.isArray())
          arr = doc.array();

        for (const QJsonValue &val : arr) {
          QJsonObject obj = val.toObject();
          Conversation c;
          c.partnerId = obj["partner_id"].toInt();
          c.username = obj["username"].toString();
          c.avatarColor = obj["avatar"].toString();
          c.lastMsg = obj["last_message"].toString();
          c.time = obj["timestamp"].toString();
          c.unread =
              obj["read"].toBool() == false; // if unread is true means NOT read
          // Server logic: "read" bool. unread = !read.
          // Wait. Server "read": bool(last_msg['read']). 0 or 1.
          // If read=1, unread=false.
          c.unread = !obj["read"].toBool();

          m_conversations.append(c);
        }

        endResetModel();
        qDebug() << "Conversations refreshed:" << m_conversations.size();
      },
      [](QString err) { qWarning() << "Conversation refresh failed" << err; });
}

void ConversationModel::deleteConversation(int index) {
  if (index < 0 || index >= m_conversations.size())
    return;
  int partnerId = m_conversations[index].partnerId;
  QString userId = NetworkManager::instance().getToken();
  if (userId.isEmpty())
    return;

  QJsonObject data;
  data["user_id"] = userId.toInt();

  QString endpoint =
      QString("/api/conversations/%1?user_id=%2").arg(partnerId).arg(userId);

  NetworkManager::instance().delete_(
      endpoint, data,
      [this, index](const QJsonDocument &doc) {
        beginRemoveRows(QModelIndex(), index, index);
        m_conversations.removeAt(index);
        endRemoveRows();
      },
      [](QString err) { qWarning() << "Delete convo failed:" << err; });
}
