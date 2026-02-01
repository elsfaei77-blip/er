#pragma once
#include <QAbstractListModel>
#include <QString>
#include <QVector>

struct SearchUser {
  int id;
  QString username;
  QString fullName;
  QString avatarColor;
};

/**
 * Model for user search results
 */
class SearchViewModel : public QAbstractListModel {
  Q_OBJECT

public:
  enum Roles {
    IdRole = Qt::UserRole + 1,
    UsernameRole,
    FullNameRole,
    AvatarColorRole
  };

  explicit SearchViewModel(QObject *parent = nullptr);

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE void search(const QString &query);
  Q_INVOKABLE void follow(int index);

private:
  QVector<SearchUser> m_users;
};
