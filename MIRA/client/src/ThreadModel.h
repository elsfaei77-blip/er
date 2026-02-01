#pragma once
#include <QAbstractListModel>
#include <QHash>
#include <QObject>
#include <QString>
#include <QVariant>
#include <QVector>

struct Post {
  int id;
  int userId; // New
  QString author;
  QString handle;
  QString content;
  QString time;
  QString avatarColor;
  int likesCount;
  int replyCount;
  bool isLiked;
  bool isVerified;
  QString imageUrl;
  QString videoUrl;
  QString reactionType;
  QString reactionSummary;
};

struct Story {
  int id;
  int userId;
  QString username;
  QString avatar;
  QString mediaUrl;
  QString mediaType;
  QString timestamp;
  bool isFollowing;
};

class ThreadModel : public QAbstractListModel {
  Q_OBJECT
  Q_PROPERTY(QVariantList stories READ stories NOTIFY storiesChanged)
  Q_PROPERTY(bool hasActiveStory READ hasActiveStory NOTIFY storiesChanged)

public:
  enum Roles {
    IdRole = Qt::UserRole + 1,
    UserIdRole, // New
    AuthorRole,
    HandleRole,
    ContentRole,
    TimeRole,
    AvatarColorRole,
    LikesCountRole,
    ReplyCountRole,
    IsLikedRole,
    IsVerifiedRole,
    ImageUrlRole,
    VideoUrlRole,
    ReactionRole,
    ReactionSummaryRole
  };

  explicit ThreadModel(QObject *parent = nullptr);

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE void refresh(int targetUserId = 0, const QString &filter = "");
  Q_INVOKABLE void refreshStories();
  Q_INVOKABLE void createPost(const QString &content,
                              const QString &mediaPath = "");
  Q_INVOKABLE void createStory(const QString &mediaPath);
  Q_INVOKABLE void toggleLike(int index);
  Q_INVOKABLE void react(int index, const QString &type);
  Q_INVOKABLE void deletePost(int index);
  Q_INVOKABLE void editPost(int index, const QString &newContent);
  Q_INVOKABLE void deleteStory(int storyId);
  Q_INVOKABLE void blockUser(int index);

  // New Interactions
  Q_INVOKABLE void requestReply(int index); // Signals to open dialog
  Q_INVOKABLE void addComment(int index, const QString &content, int userId);
  Q_INVOKABLE void repost(int index, int userId);
  Q_INVOKABLE void share(int index);

  QVariantList stories() const;
  bool hasActiveStory() const;
  Q_INVOKABLE bool hasUserActiveStory(int userId) const;
  Q_INVOKABLE QVariantMap getStoriesForUser(int userId) const;

signals:
  void replyRequested(int index, const QString &author);
  void storiesChanged();

private:
  QVector<Post> m_posts;
  QVector<Story> m_stories;
};
