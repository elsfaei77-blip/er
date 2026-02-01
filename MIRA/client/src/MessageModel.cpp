#include "MessageModel.h"
#include "NetworkManager.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

MessageModel::MessageModel(QObject *parent) : QAbstractListModel(parent) {}

int MessageModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid())
    return 0;
  return m_messages.size();
}

QVariant MessageModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_messages.size())
    return QVariant();

  const Message &m = m_messages[index.row()];
  switch (role) {
  case IdRole:
    return m.id;
  case ContentRole:
    return m.content;
  case IsMeRole:
    return m.isMe;
  case TimeRole:
    return m.time;
  case ReactionRole:
    return m.reaction;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> MessageModel::roleNames() const {
  return {{IdRole, "id"},
          {ContentRole,
           "text"}, // match QML property name if possible, QML uses 'text'
          {IsMeRole, "sentByUser"}, // QML uses sentByUser
          {TimeRole, "time"},
          {ReactionRole, "reaction"}};
}

void MessageModel::setPartnerId(int pid) {
  if (m_partnerId == pid)
    return;
  m_partnerId = pid;
  emit partnerIdChanged();
  refresh(); // Auto refresh when partner changes
}

void MessageModel::refresh() {
  if (m_partnerId == 0)
    return;
  int currentUserId = NetworkManager::instance().getUserId();
  QString userId = (currentUserId > 0) ? QString::number(currentUserId) : "0";

  QString endpoint =
      QString("/api/messages/%1?user_id=%2").arg(m_partnerId).arg(userId);

  NetworkManager::instance().get(
      endpoint,
      [this](const QJsonDocument &doc) {
        beginResetModel();
        m_messages.clear();

        QJsonArray arr;
        if (doc.isArray())
          arr = doc.array();

        for (const QJsonValue &val : arr) {
          QJsonObject obj = val.toObject();
          Message m;
          m.id = obj["id"].toInt();
          m.content = obj["content"].toString();
          m.isMe = obj["is_me"].toBool();
          m.time = obj["timestamp"].toString();
          // reaction not supported by server yet, default empty
          m.reaction = "";
          m_messages.append(m);
        }
        endResetModel();
      },
      [](QString error) { qWarning() << "Fetch messages failed:" << error; });
}

void MessageModel::sendMessage(const QString &text) {
  if (m_partnerId == 0 || text.isEmpty())
    return;

  QString userId = NetworkManager::instance().getToken();
  QJsonObject data;
  data["user_id"] = userId.toInt();
  data["content"] = text;

  QString endpoint = QString("/api/messages/%1").arg(m_partnerId);

  NetworkManager::instance().post(
      endpoint, data, [this](const QJsonDocument &doc) { refresh(); },
      [](QString err) { qWarning() << "Send msg failed:" << err; });
}

void MessageModel::addReaction(int index, const QString &emoji) {
  // Optimistic
  if (index >= 0 && index < m_messages.size()) {
    m_messages[index].reaction = emoji;
    emit dataChanged(this->index(index), this->index(index), {ReactionRole});
  }
  // No Server API for reaction on messages yet.
}

void MessageModel::deleteMessage(int index) {
  if (index < 0 || index >= m_messages.size())
    return;
  int messageId = m_messages[index].id;
  QString userId = NetworkManager::instance().getToken();
  if (userId.isEmpty())
    return;

  QJsonObject data;
  data["user_id"] = userId.toInt();

  QString endpoint = QString("/api/messages/%1").arg(messageId);

  NetworkManager::instance().delete_(
      endpoint, data,
      [this, index](const QJsonDocument &doc) {
        beginRemoveRows(QModelIndex(), index, index);
        m_messages.removeAt(index);
        endRemoveRows();
      },
      [](QString err) { qWarning() << "Delete msg failed:" << err; });
}

void MessageModel::editMessage(int index, const QString &text) {
  if (index < 0 || index >= m_messages.size())
    return;
  int messageId = m_messages[index].id;
  QString userId = NetworkManager::instance().getToken();
  if (userId.isEmpty())
    return;

  QJsonObject data;
  data["user_id"] = userId.toInt();
  data["content"] = text;

  QString endpoint = QString("/api/messages/%1").arg(messageId);

  NetworkManager::instance().put(
      endpoint, data,
      [this, index, text](const QJsonDocument &doc) {
        m_messages[index].content = text;
        emit dataChanged(this->index(index), this->index(index), {ContentRole});
      },
      [](QString err) { qWarning() << "Edit msg failed:" << err; });
}
