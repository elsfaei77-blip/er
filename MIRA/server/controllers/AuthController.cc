#include "AuthController.h"
#include <drogon/orm/DbClient.h>

void AuthController::login(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback) {
  auto json = req->getJsonObject();
  if (!json) {
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k400BadRequest);
    callback(resp);
    return;
  }

  auto username = (*json)["username"].asString();
  auto password = (*json)["password"].asString();

  auto client = app().getDbClient();
  try {
    auto result =
        client->execSqlSync("SELECT * FROM users WHERE username = ?", username);
    if (result.empty()) {
      Json::Value ret;
      ret["error"] = "Invalid credentials";
      auto resp = HttpResponse::newHttpJsonResponse(ret);
      resp->setStatusCode(k401Unauthorized);
      callback(resp);
      return;
    }

    auto row = result[0];
    std::string dbPass = row["password"].as<std::string>();
    // Check hash (Simplified: using sha256 of input)
    std::string inputHash = drogon::utils::getSha256(password);

    if (dbPass != inputHash) {
      Json::Value ret;
      ret["error"] = "Invalid credentials";
      auto resp = HttpResponse::newHttpJsonResponse(ret);
      resp->setStatusCode(k401Unauthorized);
      callback(resp);
      return;
    }

    // Success
    Json::Value ret;
    ret["status"] = "success";
    ret["user_id"] = row["id"].as<int>();
    ret["username"] = row["username"].as<std::string>();
    ret["avatar"] = row["avatar"].as<std::string>();
    ret["token"] = std::to_string(row["id"].as<int>()); // Simple token

    callback(HttpResponse::newHttpJsonResponse(ret));
  } catch (const std::exception &e) {
    LOG_ERROR << e.what();
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k500InternalServerError);
    callback(resp);
  }
}

void AuthController::registerUser(
    const HttpRequestPtr &req,
    std::function<void(const HttpResponsePtr &)> &&callback) {
  auto json = req->getJsonObject();
  if (!json) {
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k400BadRequest);
    callback(resp);
    return;
  }

  auto username = (*json)["username"].asString();
  auto password = (*json)["password"].asString();

  if (username.empty() || password.empty()) {
    Json::Value ret;
    ret["error"] = "Missing fields";
    auto resp = HttpResponse::newHttpJsonResponse(ret);
    resp->setStatusCode(k400BadRequest);
    callback(resp);
    return;
  }

  auto client = app().getDbClient();
  try {
    // Hash password
    std::string hashed = drogon::utils::getSha256(password);

    std::string userAgent = req->getHeader("User-Agent");
    std::string device = "Desktop";
    if (userAgent.find("Android") != std::string::npos)
      device = "Android";
    else if (userAgent.find("iPhone") != std::string::npos)
      device = "iOS";

    std::string country = req->getHeader("CF-IPCountry");
    if (country.empty())
      country = "Unknown";

    // --- EMAIL VERIFICATION CHECK ---
    std::string email =
        json->isMember("email") ? (*json)["email"].asString() : "";
    std::string code = json->isMember("verification_code")
                           ? (*json)["verification_code"].asString()
                           : "";

    // Require email/code if not explicitly skipped (e.g. legacy/testing)
    // For this requirement, we enforce it.
    if (email.empty() || code.empty()) {
      Json::Value ret;
      ret["error"] = "Email and verification code required";
      auto resp = HttpResponse::newHttpJsonResponse(ret);
      resp->setStatusCode(k400BadRequest);
      callback(resp);
      return;
    }

    auto verifyRes = client->execSqlSync(
        "SELECT created_at, "
        "(CAST(strftime('%s', 'now') AS INTEGER) - CAST(strftime('%s', "
        "created_at) AS INTEGER)) as age_seconds "
        "FROM email_verifications WHERE email = ? AND code = ?",
        email, code);

    if (verifyRes.empty()) {
      // Double check if code exists but is wrong vs email not found?
      // Requirement: "Wrong Code"
      Json::Value ret;
      ret["error"] = "Invalid verification code"; // The user specified "Wrong
                                                  // Code" (الرمز خاطئ)
      auto resp = HttpResponse::newHttpJsonResponse(ret);
      resp->setStatusCode(k400BadRequest);
      callback(resp);
      return;
    }

    int age = verifyRes[0]["age_seconds"].as<int>();
    if (age > 180) { // 3 minutes = 180 seconds
      Json::Value ret;
      ret["error"] =
          "Verification code expired"; // The user specified "Expired" (الرمز
                                       // منتهي الصلاحية)
      auto resp = HttpResponse::newHttpJsonResponse(ret);
      resp->setStatusCode(k400BadRequest);
      callback(resp);
      return;
    }

    // Code is valid and fresh. Proceed to create user.
    // Clean up verification code?
    // client->execSqlSync("DELETE FROM email_verifications WHERE email = ?",
    // email);

    client->execSqlSync(
        "INSERT INTO users (username, password, email, avatar, bio, "
        "device_type, country) "
        "VALUES (?, ?, ?, ?, ?, ?, ?)",
        username, hashed, email, std::string(""), std::string("New to MIRA"),
        device, country);

    Json::Value ret;
    ret["status"] = "success";
    callback(HttpResponse::newHttpJsonResponse(ret));

  } catch (const drogon::orm::DrogonDbException &e) {
    // Assuming unique constraint violation
    Json::Value ret;
    ret["error"] = "Username taken";
    auto resp = HttpResponse::newHttpJsonResponse(ret);
    resp->setStatusCode(k409Conflict);
    callback(resp);
  } catch (const std::exception &e) {
    LOG_ERROR << e.what();
    auto resp = HttpResponse::newHttpResponse();
    resp->setStatusCode(k500InternalServerError);
    callback(resp);
  }
}
