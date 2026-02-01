#include <drogon/HttpAppFramework.h>
#include <drogon/drogon.h>
#include <drogon/orm/DbClient.h>
#include <filesystem>
#include <iostream>

using namespace drogon;

void initDatabase() {
  auto db = app().getDbClient();
  if (!db) {
    LOG_ERROR << "Database client not found!";
    return;
  }

  // Users
  db->execSqlSync("CREATE TABLE IF NOT EXISTS users ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "username TEXT UNIQUE NOT NULL,"
                  "password TEXT NOT NULL,"
                  "avatar TEXT,"
                  "bio TEXT,"
                  "device_type TEXT,"
                  "country TEXT,"
                  "created_at DATETIME DEFAULT CURRENT_TIMESTAMP)");

  // Migration: Add google_id and email to users if not exists
  LOG_INFO << "Checking Migrations...";
  try {
    db->execSqlSync("ALTER TABLE users ADD COLUMN google_id TEXT");
    LOG_INFO << "Migration: Added google_id column.";
  } catch (...) {
    // Ignore if exists
  }

  try {
    // SQLite allows multiple NULLs in UNIQUE column by default, so this is safe
    // for existing users
    db->execSqlSync("CREATE UNIQUE INDEX IF NOT EXISTS idx_users_google_id ON "
                    "users(google_id)");
    LOG_INFO << "Migration: Created google_id index.";
  } catch (const std::exception &e) {
    LOG_WARN << "Migration (index google_id) failed: " << e.what();
  }

  try {
    db->execSqlSync("ALTER TABLE users ADD COLUMN email TEXT");
    LOG_INFO << "Migration: Added email column.";
  } catch (...) {
  }

  // Posts
  db->execSqlSync("CREATE TABLE IF NOT EXISTS posts ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "user_id INTEGER NOT NULL,"
                  "content TEXT,"
                  "media_url TEXT,"
                  "media_type TEXT,"
                  "timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,"
                  "FOREIGN KEY(user_id) REFERENCES users(id))");

  // Likes
  db->execSqlSync("CREATE TABLE IF NOT EXISTS likes ("
                  "user_id INTEGER,"
                  "post_id INTEGER,"
                  "PRIMARY KEY (user_id, post_id))");

  // Migration: Add type to likes if not exists
  try {
    db->execSqlSync("ALTER TABLE likes ADD COLUMN type TEXT DEFAULT 'like'");
  } catch (...) {
    // Ignore "duplicate column name" error
  }

  // Migration: Add post_type to posts if not exists
  try {
    db->execSqlSync(
        "ALTER TABLE posts ADD COLUMN post_type TEXT DEFAULT 'post'");
  } catch (...) {
  }

  // Comments
  db->execSqlSync("CREATE TABLE IF NOT EXISTS comments ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "post_id INTEGER,"
                  "user_id INTEGER,"
                  "content TEXT,"
                  "timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)");

  // Follows
  db->execSqlSync("CREATE TABLE IF NOT EXISTS follows ("
                  "follower_id INTEGER,"
                  "followed_id INTEGER,"
                  "PRIMARY KEY (follower_id, followed_id))");

  // Notifications
  db->execSqlSync("CREATE TABLE IF NOT EXISTS notifications ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "user_id INTEGER NOT NULL,"  // Recipient
                  "actor_id INTEGER NOT NULL," // Actor
                  "type TEXT NOT NULL,"
                  "post_id INTEGER,"
                  "read INTEGER DEFAULT 0,"
                  "timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,"
                  "FOREIGN KEY(user_id) REFERENCES users(id),"
                  "FOREIGN KEY(actor_id) REFERENCES users(id))");

  // Messages
  db->execSqlSync("CREATE TABLE IF NOT EXISTS messages ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "sender_id INTEGER,"
                  "receiver_id INTEGER,"
                  "content TEXT,"
                  "media_url TEXT,"
                  "timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,"
                  "read INTEGER DEFAULT 0)");

  // Blocks
  db->execSqlSync("CREATE TABLE IF NOT EXISTS blocks ("
                  "blocker_id INTEGER,"
                  "blocked_id INTEGER,"
                  "PRIMARY KEY (blocker_id, blocked_id))");

  // SEED: Welcome Post (Only if empty)
  auto res = db->execSqlSync("SELECT COUNT(*) FROM posts");
  if (!res.empty() && res[0][0].as<int>() == 0) {
    db->execSqlSync("INSERT INTO users (username, password, avatar, bio) "
                    "VALUES (?, ?, ?, ?)",
                    "mira_team", "no_login",
                    "https://api.dicebear.com/7.x/bottts/svg?seed=mira",
                    "The MIRA Team");
    db->execSqlSync("INSERT INTO posts (user_id, content) VALUES (1, ?)",
                    "Welcome to MIRA! 🚀 We've just updated the app with "
                    "high-fidelity professional features. Start threading, "
                    "sharing stories, and connecting! ✨");
    db->execSqlSync("INSERT INTO posts (user_id, content) VALUES (1, ?)",
                    "Welcome to MIRA! 🚀 We've just updated the app with "
                    "high-fidelity professional features. Start threading, "
                    "sharing stories, and connecting! ✨");
  }

  // Email Verifications (New)
  db->execSqlSync("CREATE TABLE IF NOT EXISTS email_verifications ("
                  "email TEXT PRIMARY KEY,"
                  "code TEXT NOT NULL,"
                  "created_at DATETIME DEFAULT CURRENT_TIMESTAMP)");

  LOG_INFO << "Database Initialized.";
}

int main() {
  app().loadConfigFile("config.json");

  // Set absolute paths AFTER loading config to avoid overrides
  std::string workingDir = std::filesystem::current_path().string();
  app().setDocumentRoot(workingDir + "/static");
  app().setUploadPath("uploads");                // Relative to DocumentRoot
  app().setClientMaxBodySize(100 * 1024 * 1024); // 100MB

  // IMPORTANT: Allow media file types for downloading/streaming
  app().setFileTypes({"html", "js", "css", "xml", "png", "jpg", "jpeg", "gif",
                      "mp4", "mov", "avi"});

  app().registerBeginningAdvice([]() {
    initDatabase();
    std::string workingDir = std::filesystem::current_path().string();
    LOG_INFO << "Server Working Directory: " << workingDir;
    std::filesystem::create_directories(workingDir + "/static/uploads");
  });

  LOG_INFO << "Server running on 0.0.0.0:8000";

  LOG_INFO << "Server running on 0.0.0.0:8000";
  app().run();
  return 0;
}
