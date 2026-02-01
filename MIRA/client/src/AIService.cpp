#include "AIService.h"
#include <QRandomGenerator>
#include <QTimer>


AIService::AIService(QObject *parent) : QObject(parent) {}

void AIService::setProcessing(bool processing) {
  if (m_isProcessing != processing) {
    m_isProcessing = processing;
    emit isProcessingChanged();
  }
}

void AIService::askMira(const QString &query) {
  setProcessing(true);

  // Simulate thinking time
  QTimer::singleShot(1500, this, [this, query]() {
    QString response;
    QString lowerQuery = query.toLower();

    if (lowerQuery.contains("trending") || lowerQuery.contains("explore")) {
      response =
          "Currently, #Flutter, #C++ and #MIRA are trending in your network. "
          "People are also discussing the new glassmorphism UI update!";
    } else if (lowerQuery.contains("who am i")) {
      response = "You are a valued member of the MIRA community! Your recent "
                 "threads have gained quite a bit of traction.";
    } else if (lowerQuery.contains("tips")) {
      response = "Pro tip: Use high-quality images and engaging questions to "
                 "increase your reach on MIRA.";
    } else {
      response = "That's an interesting question! As your AI assistant, I'm "
                 "here to help you navigate MIRA. You can ask me about "
                 "trending topics, profile tips, or how to use the app.";
    }

    setProcessing(false);
    emit responseReceived(response);
  });
}

QVariantList AIService::getDiscoveryCards() {
  QVariantList cards;

  QVariantMap card1;
  card1["title"] = "Trending Now";
  card1["description"] = "Explaining the rise of AI in social media.";
  card1["tag"] = "Tech";
  card1["color"] = "#8B5CF6";
  cards.append(card1);

  QVariantMap card2;
  card2["title"] = "AI Pick";
  card2["description"] = "User @sf_dev just posted a stunning 3D render.";
  card2["tag"] = "Art";
  card2["color"] = "#EC4899";
  cards.append(card2);

  QVariantMap card3;
  card3["title"] = "For You";
  card3["description"] = "New features coming to MIRA this week.";
  card3["tag"] = "Updates";
  card3["color"] = "#007AFF";
  cards.append(card3);

  return cards;
}
