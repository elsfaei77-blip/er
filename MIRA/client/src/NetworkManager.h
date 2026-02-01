#pragma once
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QObject>
#include <QString>
#include <functional>

class NetworkManager : public QObject {
  Q_OBJECT
public:
  static NetworkManager &instance();

  void setToken(const QString &token);
  QString getToken() const;

  void setUserId(int id);
  int getUserId() const;

  // Callbacks receive the full QJsonDocument
  using SuccessCallback = std::function<void(const QJsonDocument &)>;
  using ErrorCallback = std::function<void(QString)>;

  void get(const QString &endpoint, SuccessCallback onSuccess,
           ErrorCallback onError = nullptr);
  void post(const QString &endpoint, const QJsonObject &data,
            SuccessCallback onSuccess, ErrorCallback onError = nullptr);
  void put(const QString &endpoint, const QJsonObject &data,
           SuccessCallback onSuccess, ErrorCallback onError = nullptr);
  void delete_(const QString &endpoint, const QJsonObject &data,
               SuccessCallback onSuccess, ErrorCallback onError = nullptr);
  void upload(const QString &endpoint, const QString &filePath,
              SuccessCallback onSuccess, ErrorCallback onError = nullptr);

private:
  NetworkManager();
  QNetworkAccessManager *m_manager;
  QString m_token;
  int m_userId = 0;
#ifdef Q_OS_ANDROID
  // Physical device IP: 192.168.8.178
  const QString m_baseUrl = "http://192.168.8.178:8000";
#else
  const QString m_baseUrl = "http://localhost:8000";
#endif
};
