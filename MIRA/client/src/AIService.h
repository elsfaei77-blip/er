#ifndef AISERVICE_H
#define AISERVICE_H

#include <QObject>
#include <QStringList>
#include <QVariantMap>

class AIService : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool isProcessing READ isProcessing NOTIFY isProcessingChanged)

public:
  explicit AIService(QObject *parent = nullptr);

  Q_INVOKABLE void askMira(const QString &query);
  Q_INVOKABLE QVariantList getDiscoveryCards();

  bool isProcessing() const { return m_isProcessing; }

signals:
  void responseReceived(const QString &response);
  void isProcessingChanged();

private:
  bool m_isProcessing = false;
  void setProcessing(bool processing);
};

#endif // AISERVICE_H
