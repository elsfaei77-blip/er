#pragma once
#include <QAbstractListModel>
#include <QVector>

struct Conversation {
  int partnerId;
  QString username;
  QString avatarColor;
  QString lastMsg;
  QString time;
  bool unread;
};

class ConversationModel : public QAbstractListModel {
  Q_OBJECT
public:
  enum Roles {
    PartnerIdRole = Qt::UserRole + 1,
    UsernameRole,
    AvatarColorRole,
    LastMsgRole,
    TimeRole,
    UnreadRole
  };

  explicit ConversationModel(QObject *parent = nullptr);
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE void refresh();
  Q_INVOKABLE void deleteConversation(int index);

private:
  QVector<Conversation> m_conversations;
};
