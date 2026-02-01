#pragma once
#include <QAbstractListModel>
#include <QVector>

struct Message {
  int id;
  int senderId;
  QString content;
  QString mediaUrl;
  QString time;
  bool isMe;
  QString reaction;
};

class MessageModel : public QAbstractListModel {
  Q_OBJECT
  Q_PROPERTY(
      int partnerId READ partnerId WRITE setPartnerId NOTIFY partnerIdChanged)

public:
  enum Roles {
    IdRole = Qt::UserRole + 1,
    ContentRole,
    IsMeRole,
    TimeRole,
    ReactionRole
  };

  explicit MessageModel(QObject *parent = nullptr);
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

  int partnerId() const { return m_partnerId; }
  void setPartnerId(int pid);

  Q_INVOKABLE void refresh();
  Q_INVOKABLE void sendMessage(const QString &text);
  Q_INVOKABLE void addReaction(int index, const QString &emoji);
  Q_INVOKABLE void deleteMessage(int index);
  Q_INVOKABLE void editMessage(int index, const QString &text);

signals:
  void partnerIdChanged();

private:
  QVector<Message> m_messages;
  int m_partnerId = 0;
};
