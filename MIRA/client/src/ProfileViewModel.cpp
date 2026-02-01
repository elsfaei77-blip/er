#include "ProfileViewModel.h"
#include "NetworkManager.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>

ProfileViewModel::ProfileViewModel(QObject *parent) : QObject(parent) {}

void ProfileViewModel::loadProfile(int userId) {
  m_userId = userId;
  QString viewerId = NetworkManager::instance().getToken();
  if (viewerId.isEmpty())
    viewerId = "0";

  // Reset state to avoid showing stale data
  m_username = "";
  m_fullName = "";
  m_bio = "";
  m_avatarColor = "";
  m_followersCount = 0;
  m_followingCount = 0;
  m_isFollowing = false;
  emit profileChanged();

  QString endpoint =
      QString("/api/user/%1/profile?viewer_id=%2").arg(userId).arg(viewerId);

  NetworkManager::instance().get(
      endpoint,
      [this](const QJsonDocument &doc) {
        QJsonObject data = doc.object();

        m_username = data["username"].toString();
        m_fullName = data["username"].toString(); // Fallback
        m_bio = data["bio"].toString();
        m_avatarColor = data["avatar"].toString();
        m_followersCount = data["followers"].toInt();
        m_followingCount = data["following"].toInt();
        m_isFollowing = data["is_following"].toBool();
        m_isBlocked = data["is_blocked"].toBool();
        m_postsCount = data["posts_count"].toInt();
        m_deviceType = data["device_type"].toString();
        m_country = data["country"].toString();
        m_createdAt = data["created_at"].toString();

        emit profileChanged();

        qDebug() << "Profile loaded:" << m_username;
      },
      [](QString error) { qWarning() << "Load profile failed:" << error; });
}

void ProfileViewModel::toggleFollow() {
  QString viewerId = NetworkManager::instance().getToken();
  if (viewerId.isEmpty())
    return;

  QJsonObject data;
  data["user_id"] = viewerId.toInt();

  QString endpoint = QString("/api/follow/%1").arg(m_userId);

  NetworkManager::instance().post(
      endpoint, data,
      [this](const QJsonDocument &doc) {
        QJsonObject res = doc.object();
        QString action = res["action"].toString();
        bool nowFollowing = (action == "followed");

        // Update state
        m_isFollowing = nowFollowing;
        m_followersCount += (nowFollowing ? 1 : -1);

        emit profileChanged();

        qDebug() << "Follow toggled:" << nowFollowing;
      },
      [](QString error) { qWarning() << "Toggle follow failed:" << error; });
}

void ProfileViewModel::updateProfile(const QString &bio,
                                     const QString &avatar) {
  int currentUserId = NetworkManager::instance().getToken().toInt();
  if (currentUserId == 0)
    return;

  QJsonObject data;
  data["user_id"] = currentUserId;
  data["bio"] = bio;
  if (!avatar.isEmpty())
    data["avatar"] = avatar;

  NetworkManager::instance().post(
      "/api/profile/update", data,
      [this, bio, avatar](const QJsonDocument &doc) {
        m_bio = bio;
        if (!avatar.isEmpty())
          m_avatarColor = avatar;

        qDebug() << "Profile updated. Avatar:" << m_avatarColor;
        emit profileChanged();
      },
      [](QString error) { qWarning() << "Profile update failed:" << error; });
}

void ProfileViewModel::uploadAndSetAvatar(const QString &path) {
  int viewerId = NetworkManager::instance().getToken().toInt();
  if (viewerId == 0)
    return;

  NetworkManager::instance().upload(
      "/api/upload", path,
      [this](const QJsonDocument &doc) {
        QJsonObject res = doc.object();
        QString url = res["url"].toString();

        // Update profile with new avatar URL
        // We keep the current bio
        updateProfile(m_bio, url);
        qDebug() << "Avatar uploaded and set:" << url;
      },
      [](QString error) { qWarning() << "Avatar upload failed:" << error; });
}

void ProfileViewModel::blockUser() {
  int viewerId = NetworkManager::instance().getToken().toInt();
  if (viewerId == 0)
    return;

  QJsonObject data;
  data["user_id"] = viewerId;

  QString endpoint = QString("/api/block/%1").arg(m_userId);

  NetworkManager::instance().post(
      endpoint, data,
      [this](const QJsonDocument &doc) {
        QJsonObject res = doc.object();
        QString action = res["action"].toString();
        m_isBlocked = (action == "blocked");
        emit profileChanged();
        qDebug() << "User block action:" << action;
      },
      [](QString error) { qWarning() << "Block user failed:" << error; });
}
