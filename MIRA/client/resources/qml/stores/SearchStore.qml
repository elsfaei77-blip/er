pragma Singleton
import QtQuick

QtObject {
    id: searchStore
    
    // Search Data
    property ListModel historyModel: ListModel {
        ListElement { username: "shams_dev"; name: "Shams"; seed: "shams"; isVerified: true }
        ListElement { username: "qml_expert"; name: "QML Expert"; seed: "qml"; isVerified: false }
    }
    
    property ListModel trendingModel: ListModel {
        ListElement { title: "Artificial Intelligence"; count: "845K threads" }
        ListElement { title: "Threads API"; count: "124K threads" }
        ListElement { title: "Qt 6.8 Release"; count: "52K threads" }
        ListElement { title: "Design Systems"; count: "36K threads" }
    }

    // Actions
    function addToHistory(username, name, seed, isVerified) {
        // Remove if exists to bubble to top
        for (var i = 0; i < historyModel.count; i++) {
            if (historyModel.get(i).username === username) {
                historyModel.remove(i);
                break;
            }
        }
        historyModel.insert(0, {
            "username": username,
            "name": name,
            "seed": seed,
            "isVerified": isVerified
        });
    }
    
    function clearHistory() {
        historyModel.clear();
    }
}
