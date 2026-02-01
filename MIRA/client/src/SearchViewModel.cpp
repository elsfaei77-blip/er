#include "SearchViewModel.h"
#include "NetworkManager.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>

SearchViewModel::SearchViewModel(QObject *parent)
    : QAbstractListModel(parent) {}

int SearchViewModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid())
    return 0;
  return m_users.size();
}

QVariant SearchViewModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_users.size())
    return QVariant();

  const SearchUser &user = m_users[index.row()];

  switch (role) {
  case IdRole:
    return user.id;
  case UsernameRole:
    return user.username;
  case FullNameRole:
    return user.fullName; // Server doesn't have fullName, use username
  case AvatarColorRole:
    return user.avatarColor;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> SearchViewModel::roleNames() const {
  return {{IdRole, "id"},
          {UsernameRole, "username"},
          {FullNameRole, "fullName"},
          {AvatarColorRole, "avatarColor"}};
}

void SearchViewModel::search(const QString &query) {
  if (query.isEmpty()) {
    beginResetModel();
    m_users.clear();
    endResetModel();
    return;
  }

  // URL encode query
  QString endpoint = QString("/api/search?q=%1")
                         .arg(query); // Should verify encoding, simple for now

  NetworkManager::instance().get(
      endpoint,
      [this](const QJsonDocument &doc) {
        beginResetModel();
        m_users.clear();

        QJsonObject root = doc.object();
        QJsonArray users = root["users"].toArray();

        for (const QJsonValue &val : users) {
          QJsonObject obj = val.toObject();

          SearchUser user;
          user.id = obj["id"].toInt();
          user.username = obj["username"].toString();
          user.fullName = obj["username"].toString(); // Fallback
          user.avatarColor = obj["avatar"].toString();

          m_users.append(user);
        }

        endResetModel();
        qDebug() << "Search results:" << m_users.size();
      },
      [](QString error) { qWarning() << "Search failed:" << error; });
}

void SearchViewModel::follow(int index) {
  if (index < 0 || index >= m_users.size())
    return;

  int targetId = m_users[index].id;
  QString viewerId = NetworkManager::instance().getToken();
  if (viewerId.isEmpty())
    return;

  QJsonObject data;
  data["user_id"] = viewerId.toInt();

  QString endpoint = QString("/api/follow/%1").arg(targetId);

  NetworkManager::instance().post(
      endpoint, data,
      [this, index](const QJsonDocument &doc) {
        qDebug() << "Followed user from search:" << m_users[index].username;
      },
      [](QString error) { qWarning() << "Search follow failed:" << error; });
}
