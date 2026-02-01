#pragma once
#include <QAbstractListModel>
#include <QVector>

struct Comment {
  int id;
  QString author;
  QString avatarColor;
  QString content;
  QString time;
};

class CommentModel : public QAbstractListModel {
  Q_OBJECT
  Q_PROPERTY(int postId READ postId WRITE setPostId NOTIFY postIdChanged)

public:
  enum Roles {
    IdRole = Qt::UserRole + 1,
    AuthorRole,
    AvatarColorRole,
    ContentRole,
    TimeRole
  };

  explicit CommentModel(QObject *parent = nullptr);
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

  int postId() const { return m_postId; }
  void setPostId(int id);

  Q_INVOKABLE void refresh();
  Q_INVOKABLE void addComment(const QString &text);

signals:
  void postIdChanged();

private:
  QVector<Comment> m_comments;
  int m_postId = 0;
};
