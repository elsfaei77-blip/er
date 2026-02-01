#pragma once
#include <QObject>
#include <QString>

/**
 * ViewModel for user profiles
 * - Load profile data
 * - Toggle follow
 */
class ProfileViewModel : public QObject {
  Q_OBJECT
  Q_PROPERTY(int userId READ userId NOTIFY profileChanged)
  Q_PROPERTY(QString username READ username NOTIFY profileChanged)
  Q_PROPERTY(QString fullName READ fullName NOTIFY profileChanged)
  Q_PROPERTY(QString bio READ bio NOTIFY profileChanged)
  Q_PROPERTY(QString avatarColor READ avatarColor NOTIFY profileChanged)
  Q_PROPERTY(int followersCount READ followersCount NOTIFY profileChanged)
  Q_PROPERTY(int followingCount READ followingCount NOTIFY profileChanged)
  Q_PROPERTY(bool isFollowing READ isFollowing NOTIFY profileChanged)
  Q_PROPERTY(bool isBlocked READ isBlocked NOTIFY profileChanged)
  Q_PROPERTY(int postsCount READ postsCount NOTIFY profileChanged)
  Q_PROPERTY(QString deviceType READ deviceType NOTIFY profileChanged)
  Q_PROPERTY(QString country READ country NOTIFY profileChanged)
  Q_PROPERTY(QString createdAt READ createdAt NOTIFY profileChanged)

public:
  explicit ProfileViewModel(QObject *parent = nullptr);

  int userId() const { return m_userId; }
  QString username() const { return m_username; }
  QString fullName() const { return m_fullName; }
  QString bio() const { return m_bio; }
  QString avatarColor() const { return m_avatarColor; }
  int followersCount() const { return m_followersCount; }
  int followingCount() const { return m_followingCount; }
  bool isFollowing() const { return m_isFollowing; }
  bool isBlocked() const { return m_isBlocked; }
  int postsCount() const { return m_postsCount; }
  QString deviceType() const { return m_deviceType; }
  QString country() const { return m_country; }
  QString createdAt() const { return m_createdAt; }

  Q_INVOKABLE void loadProfile(int userId);
  Q_INVOKABLE void toggleFollow();
  Q_INVOKABLE void updateProfile(const QString &bio, const QString &avatar);
  Q_INVOKABLE void uploadAndSetAvatar(const QString &path);
  Q_INVOKABLE void blockUser();

signals:
  void profileChanged();

private:
  int m_userId = 0;
  QString m_username;
  QString m_fullName;
  QString m_bio;
  QString m_avatarColor;
  int m_followersCount = 0;
  int m_followingCount = 0;
  bool m_isFollowing = false;
  bool m_isBlocked = false;
  int m_postsCount = 0;
  QString m_deviceType;
  QString m_country;
  QString m_createdAt;
};
