pragma Singleton
import QtQuick

QtObject {
    id: feedStore
    
    property ListModel threadModel: ListModel {
        ListElement {
            author: "zuck"
            content: "Welcome to Threads. Let's do this."
            time: "2h"
            avatarColor: "#0095F6"
            isVerified: true
            likesCount: 15400
            replyCount: 3420
            isLiked: true
            hasImage: false
        }
        ListElement {
            author: "mosseri"
            content: "We're building a new way to share with text. Excited to see what you all create."
            time: "4h"
            avatarColor: "#8A3FFC"
            isVerified: true
            likesCount: 8200
            replyCount: 1200
            isLiked: false
            hasImage: false
        }
    }
    
    function postThread(content, authorName, authorColor) {
        threadModel.insert(0, {
            "author": authorName || "You",
            "content": content,
            "time": "Just now",
            "avatarColor": authorColor || "#007AFF",
            "isVerified": false,
            "likesCount": 0,
            "replyCount": 0,
            "isLiked": false,
            "hasImage": false
        });
        console.log("New thread posted by", authorName);
    }
    
    function refresh() {
        // Simulate network refresh
        console.log("Refreshing feed...");
    }

    function toggleLike(index) {
        if (index >= 0 && index < threadModel.count) {
            var item = threadModel.get(index);
            var newLikedState = !item.isLiked;
            var newCount = item.likesCount + (newLikedState ? 1 : -1);
            
            threadModel.setProperty(index, "isLiked", newLikedState);
            threadModel.setProperty(index, "likesCount", newCount);
            console.log("Toggled like for index", index, "New state:", newLikedState);
        }
    }

    function replyToThread(index, content, authorName, authorColor) {
        if (index >= 0 && index < threadModel.count) {
             var item = threadModel.get(index);
             var newReplyCount = item.replyCount + 1;
             threadModel.setProperty(index, "replyCount", newReplyCount);
             console.log("Replied to thread", index, "New count:", newReplyCount);
             
             // In a real app, we would add this to a detailed replies model.
             // For now, we just update the count to show interaction.
        }
    }
}
