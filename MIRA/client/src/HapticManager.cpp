#include "HapticManager.h"
#include <QDebug>

#ifdef Q_OS_ANDROID
#include <QCoreApplication>
#include <QJniObject>
#endif

HapticManager::HapticManager(QObject *parent) : QObject(parent) {}

void HapticManager::triggerSelection() {
  qDebug() << "Haptic: Selection";
  vibrate(10);
}

void HapticManager::triggerImpactLight() {
  qDebug() << "Haptic: Impact Light";
  vibrate(15);
}

void HapticManager::triggerImpactMedium() {
  qDebug() << "Haptic: Impact Medium";
  vibrate(30);
}

void HapticManager::triggerImpactHeavy() {
  qDebug() << "Haptic: Impact Heavy";
  vibrate(50);
}

void HapticManager::triggerNotificationSuccess() {
  qDebug() << "Haptic: Notification Success";
  vibrate(20);
}

void HapticManager::triggerNotificationWarning() {
  qDebug() << "Haptic: Notification Warning";
  vibrate(40);
}

void HapticManager::triggerNotificationError() {
  qDebug() << "Haptic: Notification Error";
  vibrate(60);
}

void HapticManager::vibrate(int durationMs) {
#ifdef Q_OS_ANDROID
  QJniObject systemService = QJniObject::callStaticObjectMethod(
      "org/qtproject/qt/android/QtNative", "activity",
      "()Landroid/app/Activity;");
  if (systemService.isValid()) {
    QJniObject vibrator = systemService.callObjectMethod(
        "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;",
        QJniObject::fromString("vibrator").object<jstring>());
    if (vibrator.isValid()) {
      vibrator.callMethod<void>("vibrate", "(J)V",
                                static_cast<jlong>(durationMs));
    }
  }
#else
  qDebug() << "Haptic Fallback (Desktop):" << durationMs << "ms";
#endif
}
