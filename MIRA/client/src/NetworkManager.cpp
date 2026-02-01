#include "NetworkManager.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QHttpMultiPart>
#include <QJsonDocument>
#include <QMimeDatabase>
#include <QNetworkReply>
#include <QNetworkRequest>

NetworkManager &NetworkManager::instance() {
  static NetworkManager inst;
  return inst;
}

NetworkManager::NetworkManager() : QObject(nullptr) {
  m_manager = new QNetworkAccessManager(this);
}

void NetworkManager::setToken(const QString &token) { m_token = token; }

QString NetworkManager::getToken() const { return m_token; }

void NetworkManager::setUserId(int id) { m_userId = id; }
int NetworkManager::getUserId() const { return m_userId; }

void NetworkManager::get(const QString &endpoint, SuccessCallback onSuccess,
                         ErrorCallback onError) {
  QUrl url(m_baseUrl + endpoint);
  QNetworkRequest request(url);
  if (!m_token.isEmpty()) {
    request.setRawHeader("Authorization", m_token.toUtf8());
  }

  qDebug() << "GET" << url.toString();
  QNetworkReply *reply = m_manager->get(request);

  connect(reply, &QNetworkReply::finished, this, [=]() {
    if (reply->error() != QNetworkReply::NoError) {
      if (onError)
        onError(reply->errorString());
      reply->deleteLater();
      return;
    }
    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (onSuccess)
      onSuccess(doc);
    reply->deleteLater();
  });
}

void NetworkManager::post(const QString &endpoint, const QJsonObject &data,
                          SuccessCallback onSuccess, ErrorCallback onError) {
  QUrl url(m_baseUrl + endpoint);
  QNetworkRequest request(url);
  request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
  if (!m_token.isEmpty()) {
    request.setRawHeader("Authorization", m_token.toUtf8());
  }

  QJsonDocument doc(data);
  QByteArray jsonData = doc.toJson();

  qDebug() << "POST" << url.toString() << jsonData;
  QNetworkReply *reply = m_manager->post(request, jsonData);

  connect(reply, &QNetworkReply::finished, this, [=]() {
    if (reply->error() != QNetworkReply::NoError) {
      if (onError)
        onError(reply->errorString());
      reply->deleteLater();
      return;
    }
    QByteArray res = reply->readAll();
    QJsonDocument resDoc = QJsonDocument::fromJson(res);
    if (onSuccess)
      onSuccess(resDoc);
    reply->deleteLater();
  });
}

void NetworkManager::put(const QString &endpoint, const QJsonObject &data,
                         SuccessCallback onSuccess, ErrorCallback onError) {
  QUrl url(m_baseUrl + endpoint);
  QNetworkRequest request(url);
  request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
  if (!m_token.isEmpty()) {
    request.setRawHeader("Authorization", m_token.toUtf8());
  }

  QJsonDocument doc(data);
  QByteArray jsonData = doc.toJson();

  qDebug() << "PUT" << url.toString() << jsonData;
  QNetworkReply *reply = m_manager->put(request, jsonData);

  connect(reply, &QNetworkReply::finished, this, [=]() {
    if (reply->error() != QNetworkReply::NoError) {
      if (onError)
        onError(reply->errorString());
      reply->deleteLater();
      return;
    }
    QByteArray res = reply->readAll();
    QJsonDocument resDoc = QJsonDocument::fromJson(res);
    if (onSuccess)
      onSuccess(resDoc);
    reply->deleteLater();
  });
}

void NetworkManager::delete_(const QString &endpoint, const QJsonObject &data,
                             SuccessCallback onSuccess, ErrorCallback onError) {
  QUrl url(m_baseUrl + endpoint);
  QNetworkRequest request(url);
  request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
  if (!m_token.isEmpty()) {
    request.setRawHeader("Authorization", m_token.toUtf8());
  }

  QJsonDocument doc(data);
  QByteArray jsonData = doc.toJson();

  qDebug() << "DELETE" << url.toString() << jsonData;

  QNetworkReply *reply =
      m_manager->sendCustomRequest(request, "DELETE", jsonData);

  connect(reply, &QNetworkReply::finished, this, [=]() {
    if (reply->error() != QNetworkReply::NoError) {
      if (onError)
        onError(reply->errorString());
      reply->deleteLater();
      return;
    }
    QByteArray res = reply->readAll();
    QJsonDocument resDoc = QJsonDocument::fromJson(res);
    if (onSuccess)
      onSuccess(resDoc);
    reply->deleteLater();
  });
}

void NetworkManager::upload(const QString &endpoint, const QString &filePath,
                            SuccessCallback onSuccess, ErrorCallback onError) {
  QUrl url(m_baseUrl + endpoint);
  QNetworkRequest request(url);
  if (!m_token.isEmpty()) {
    request.setRawHeader("Authorization", m_token.toUtf8());
  }

  QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
  QHttpPart imagePart;

  QString cleanPath = filePath;
  QUrl fileUrl(filePath);
  if (fileUrl.isLocalFile()) {
    cleanPath = fileUrl.toLocalFile();
  } else {
    if (cleanPath.startsWith("file:///"))
      cleanPath = cleanPath.mid(8);
    else if (cleanPath.startsWith("file://"))
      cleanPath = cleanPath.mid(7);
  }

  qDebug() << "NetworkManager: Attempting to upload file:" << cleanPath;

  QFile *file = new QFile(cleanPath);
  if (!file->open(QIODevice::ReadOnly)) {
    QString errorMsg =
        QString("Could not open file for upload: %1").arg(cleanPath);
    qWarning() << errorMsg;
    if (onError)
      onError(errorMsg);
    delete multiPart;
    delete file;
    return;
  }

  QMimeDatabase db;
  QMimeType mime = db.mimeTypeForFile(cleanPath);
  imagePart.setHeader(QNetworkRequest::ContentTypeHeader, mime.name());

  QString filename = QFileInfo(cleanPath).fileName();
  imagePart.setHeader(
      QNetworkRequest::ContentDispositionHeader,
      QString("form-data; name=\"file\"; filename=\"%1\"").arg(filename));

  imagePart.setBodyDevice(file);
  file->setParent(multiPart);
  multiPart->append(imagePart);

  qDebug() << "NetworkManager: Sending POST to" << url.toString() << "with file"
           << filename;

  QNetworkReply *reply = m_manager->post(request, multiPart);
  multiPart->setParent(reply);

  connect(reply, &QNetworkReply::finished, this, [=]() {
    if (reply->error() != QNetworkReply::NoError) {
      if (onError)
        onError(reply->errorString());
      reply->deleteLater();
      return;
    }
    QByteArray res = reply->readAll();
    QJsonDocument resDoc = QJsonDocument::fromJson(res);
    if (onSuccess)
      onSuccess(resDoc);
    reply->deleteLater();
  });
}
