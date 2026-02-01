#include "DatabaseManager.h"

DatabaseManager &DatabaseManager::instance() {
  static DatabaseManager instance;
  return instance;
}

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {
  QString dataLocation =
      QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
  QDir dir(dataLocation);
  if (!dir.exists()) {
    dir.mkpath(".");
  }
  m_dbPath = dir.filePath("mira_live.db");
}

DatabaseManager::~DatabaseManager() { QSqlDatabase::database().close(); }

bool DatabaseManager::init() {
  QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
  db.setDatabaseName(m_dbPath);

  qDebug() << "Database path:" << m_dbPath;

  if (!db.open()) {
    qCritical() << "Error: Connection with database failed" << db.lastError();
    return false;
  }

  return createTables();
}

QSqlDatabase DatabaseManager::database() const {
  return QSqlDatabase::database();
}

bool DatabaseManager::createTables() {
  QSqlQuery query;

  // Users Table
  if (!query.exec("CREATE TABLE IF NOT EXISTS users ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "username TEXT UNIQUE NOT NULL, "
                  "password_hash TEXT NOT NULL, "
                  "full_name TEXT, "
                  "avatar_color TEXT, "
                  "bio TEXT, "
                  "created_at DATETIME DEFAULT CURRENT_TIMESTAMP)")) {
    qCritical() << "Couldn't create users table:" << query.lastError();
    return false;
  }

  // Posts Table
  if (!query.exec("CREATE TABLE IF NOT EXISTS posts ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "user_id INTEGER NOT NULL, "
                  "content TEXT, "
                  "image_url TEXT, "
                  "reply_count INTEGER DEFAULT 0, "
                  "like_count INTEGER DEFAULT 0, "
                  "created_at DATETIME DEFAULT CURRENT_TIMESTAMP, "
                  "FOREIGN KEY(user_id) REFERENCES users(id))")) {
    qCritical() << "Couldn't create posts table:" << query.lastError();
    return false;
  }

  // Likes Table
  if (!query.exec("CREATE TABLE IF NOT EXISTS likes ("
                  "user_id INTEGER NOT NULL, "
                  "post_id INTEGER NOT NULL, "
                  "created_at DATETIME DEFAULT CURRENT_TIMESTAMP, "
                  "PRIMARY KEY (user_id, post_id), "
                  "FOREIGN KEY(user_id) REFERENCES users(id), "
                  "FOREIGN KEY(post_id) REFERENCES posts(id))")) {
    qCritical() << "Couldn't create likes table:" << query.lastError();
    return false;
  }

  return true;
}
