#include "CommentModel.h"
#include "NetworkManager.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>


CommentModel::CommentModel(QObject *parent) : QAbstractListModel(parent) {}

int CommentModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid())
    return 0;
  return m_comments.size();
}

QVariant CommentModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_comments.size())
    return QVariant();

  const Comment &c = m_comments[index.row()];
  switch (role) {
  case IdRole:
    return c.id;
  case AuthorRole:
    return c.author;
  case AvatarColorRole:
    return c.avatarColor;
  case ContentRole:
    return c.content;
  case TimeRole:
    return c.time;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> CommentModel::roleNames() const {
  return {{IdRole, "id"},
          {AuthorRole, "author"},
          {AvatarColorRole, "avatarColor"},
          {ContentRole, "content"},
          {TimeRole, "time"}};
}

void CommentModel::setPostId(int id) {
  if (m_postId == id)
    return;
  m_postId = id;
  emit postIdChanged();
  refresh();
}

void CommentModel::refresh() {
  if (m_postId == 0)
    return;

  QString endpoint = QString("/api/post/%1/comments").arg(m_postId);

  NetworkManager::instance().get(
      endpoint,
      [this](const QJsonDocument &doc) {
        beginResetModel();
        m_comments.clear();

        QJsonArray arr;
        if (doc.isArray())
          arr = doc.array();

        for (const QJsonValue &val : arr) {
          QJsonObject obj = val.toObject();
          Comment c;
          c.id = obj["id"].toInt();
          c.author = obj["username"].toString();
          c.avatarColor = obj["avatar"].toString();
          c.content = obj["content"].toString();
          c.time = obj["timestamp"].toString();
          m_comments.append(c);
        }
        endResetModel();
      },
      [](QString error) { qWarning() << "Fetch comments failed:" << error; });
}

void CommentModel::addComment(const QString &text) {
  if (m_postId == 0 || text.isEmpty())
    return;

  QString userId = NetworkManager::instance().getToken();
  if (userId.isEmpty())
    return;

  QJsonObject data;
  data["user_id"] = userId.toInt();
  data["content"] = text;

  QString endpoint = QString("/api/post/%1/comment").arg(m_postId);

  NetworkManager::instance().post(
      endpoint, data, [this](const QJsonDocument &doc) { refresh(); },
      [](QString error) { qWarning() << "Add comment failed:" << error; });
}
