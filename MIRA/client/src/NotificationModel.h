#pragma once
#include <QAbstractListModel>
#include <QVector>

struct Notification {
  int id;
  QString type; // "like", "reply", "follow"
  QString actorName;
  QString actorAvatar;
  int postId;
  QString timestamp;
  bool read;
};

class NotificationModel : public QAbstractListModel {
  Q_OBJECT
  Q_PROPERTY(int userId READ userId WRITE setUserId NOTIFY userIdChanged)

public:
  enum Roles {
    IdRole = Qt::UserRole + 1,
    TypeRole,
    ActorNameRole,
    ActorAvatarRole,
    PostIdRole,
    TimeRole,
    ReadRole
  };

  explicit NotificationModel(QObject *parent = nullptr);

  int userId() const { return m_userId; }
  void setUserId(int id);

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE void refresh();

signals:
  void userIdChanged();

private:
  QVector<Notification> m_notifications;
  int m_userId = 0;
};
