#pragma once
#include <QObject>
#include <QString>
#include <QVariantMap>

/**
 * Handles user authentication
 * - Register
 * - Login
 * - Logout
 * - Stores current user info
 */
class AuthService : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool isAuthenticated READ isAuthenticated NOTIFY authChanged)
  Q_PROPERTY(QVariantMap currentUser READ currentUser NOTIFY authChanged)

public:
  explicit AuthService(QObject *parent = nullptr);

  bool isAuthenticated() const { return m_isAuthenticated; }
  QVariantMap currentUser() const { return m_currentUser; }

  Q_INVOKABLE void login(const QString &username, const QString &password);
  Q_INVOKABLE void registerUser(const QString &username, const QString &email,
                                const QString &password,
                                const QString &verificationCode);
  Q_INVOKABLE void sendVerificationCode(const QString &email);

  Q_INVOKABLE void logout();
  Q_INVOKABLE void updateCurrentUser(const QVariantMap &userData);
  Q_INVOKABLE bool tryAutoLogin();
  Q_INVOKABLE void loginWithGoogle(const QString &email,
                                   const QString &googleId, const QString &name,
                                   const QString &avatar);

signals:
  void authChanged();
  void loginSuccess();
  void loginFailed(QString error);
  void signupSuccess();
  void signupFailed(QString error);
  void codeSentSuccess();
  void codeSentFailed(QString error);
  void logoutSuccess();

private:
  bool m_isAuthenticated = false;
  QVariantMap m_currentUser;
};
