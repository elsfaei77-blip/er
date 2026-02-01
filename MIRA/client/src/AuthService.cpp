#include "AuthService.h"
#include "NetworkManager.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>

AuthService::AuthService(QObject *parent) : QObject(parent) {}

void AuthService::login(const QString &username, const QString &password) {
  QJsonObject data;
  data["username"] = username;
  data["password"] = password;

  NetworkManager::instance().post(
      "/api/auth/login", data,
      [this](const QJsonDocument &doc) {
        QJsonObject response = doc.object();
        if (response.contains("error")) {
          emit loginFailed(response["error"].toString());
          return;
        }

        QString token = response["token"].toString();

        // Store token
        NetworkManager::instance().setToken(token);
        NetworkManager::instance().setUserId(response["user_id"].toInt());

        // Store user info
        m_currentUser.clear();
        m_currentUser["id"] = response["user_id"].toInt();
        m_currentUser["username"] = response["username"].toString();
        m_currentUser["avatar"] = response["avatar"].toString();
        m_currentUser["bio"] = "Ready to thread."; // Default or fetched

        m_isAuthenticated = true;

        // --- SAVE SESSION ---
        QSettings settings("MIRA_App", "Session");
        settings.setValue("token", token);
        settings.setValue("user_id", m_currentUser["id"]);
        settings.setValue("username", m_currentUser["username"]);
        settings.setValue("avatar", m_currentUser["avatar"]);
        settings.setValue("bio", m_currentUser["bio"]);
        // --------------------

        emit authChanged();
        emit loginSuccess();

        qDebug() << "Login successful:" << m_currentUser["username"];
      },
      [this](QString error) {
        qWarning() << "Login failed:" << error;
        emit loginFailed(error);
      });
}

void AuthService::registerUser(const QString &username, const QString &email,
                               const QString &password,
                               const QString &verificationCode) {
  QJsonObject data;
  data["username"] = username;
  data["email"] = email;
  data["password"] = password;
  data["verification_code"] = verificationCode;

  NetworkManager::instance().post(
      "/api/auth/register", data,
      [this, username, password](const QJsonDocument &doc) {
        QJsonObject res = doc.object();
        if (res.contains("error")) {
          emit signupFailed(res["error"].toString());
          return;
        }

        // Auto login
        login(username, password);
        emit signupSuccess();
      },
      [this](QString error) {
        qWarning() << "Signup failed:" << error;
        emit signupFailed(error);
      });
}

void AuthService::sendVerificationCode(const QString &email) {
  QJsonObject data;
  data["email"] = email;

  NetworkManager::instance().post(
      "/api/auth/send-code", data,
      [this](const QJsonDocument &doc) {
        QJsonObject res = doc.object();
        if (res.contains("error")) {
          emit codeSentFailed(res["error"].toString());
          return;
        }
        emit codeSentSuccess();
      },
      [this](QString error) { emit codeSentFailed(error); });
}

void AuthService::logout() {
  m_isAuthenticated = false;
  m_currentUser.clear();
  NetworkManager::instance().setToken(""); // Clear token
  NetworkManager::instance().setUserId(0);

  // --- CLEAR SESSION ---
  QSettings settings("MIRA_App", "Session");
  settings.clear();
  // --------------------

  emit authChanged();
  emit logoutSuccess();
  qDebug() << "Logged out";
}

void AuthService::updateCurrentUser(const QVariantMap &userData) {
  // Merge or replace
  for (auto it = userData.begin(); it != userData.end(); ++it) {
    m_currentUser.insert(it.key(), it.value());
  }
  emit authChanged();
}

bool AuthService::tryAutoLogin() {
  QSettings settings("MIRA_App", "Session");
  QString token = settings.value("token").toString();
  int userId = settings.value("user_id", 0).toInt();

  if (!token.isEmpty() && userId != 0) {
    m_currentUser["id"] = userId;
    m_currentUser["username"] = settings.value("username").toString();
    m_currentUser["avatar"] = settings.value("avatar").toString();
    m_currentUser["bio"] = settings.value("bio").toString();

    NetworkManager::instance().setToken(token);
    NetworkManager::instance().setUserId(userId);
    m_isAuthenticated = true;

    qDebug() << "Auto-login successful for:" << m_currentUser["username"];
    emit authChanged();
    emit loginSuccess();
    return true;
  }
  return false;
}

void AuthService::loginWithGoogle(const QString &email, const QString &googleId,
                                  const QString &name, const QString &avatar) {
  QJsonObject data;
  data["email"] = email;
  data["google_id"] = googleId;
  data["name"] = name;
  data["avatar"] = avatar;

  NetworkManager::instance().post(
      "/api/auth/google", data,
      [this](const QJsonDocument &doc) {
        QJsonObject response = doc.object();
        if (response.contains("error")) {
          emit loginFailed(response["error"].toString());
          return;
        }

        QString token = response["token"].toString();
        // Store token
        NetworkManager::instance().setToken(token);
        NetworkManager::instance().setUserId(response["user_id"].toInt());

        // Store user info
        m_currentUser.clear();
        m_currentUser["id"] = response["user_id"].toInt();
        m_currentUser["username"] = response["username"].toString();
        m_currentUser["avatar"] = response["avatar"].toString();
        m_currentUser["bio"] = "Ready to thread."; // Default or fetched

        m_isAuthenticated = true;

        // --- SAVE SESSION ---
        QSettings settings("MIRA_App", "Session");
        settings.setValue("token", token);
        settings.setValue("user_id", m_currentUser["id"]);
        settings.setValue("username", m_currentUser["username"]);
        settings.setValue("avatar", m_currentUser["avatar"]);
        settings.setValue("bio", m_currentUser["bio"]);
        // --------------------

        emit authChanged();
        emit loginSuccess();

        qDebug() << "Google Login successful:" << m_currentUser["username"];
      },
      [this](QString error) {
        qWarning() << "Google Login failed:" << error;
        emit loginFailed(error);
      });
}
