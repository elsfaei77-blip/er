#ifndef HAPTICMANAGER_H
#define HAPTICMANAGER_H

#include <QObject>
#include <QQmlEngine>

class HapticManager : public QObject {
  Q_OBJECT

public:
  explicit HapticManager(QObject *parent = nullptr);

  Q_INVOKABLE void triggerSelection();
  Q_INVOKABLE void triggerImpactLight();
  Q_INVOKABLE void triggerImpactMedium();
  Q_INVOKABLE void triggerImpactHeavy();
  Q_INVOKABLE void triggerNotificationSuccess();
  Q_INVOKABLE void triggerNotificationWarning();
  Q_INVOKABLE void triggerNotificationError();

private:
  void vibrate(int durationMs);
};

#endif // HAPTICMANAGER_H
