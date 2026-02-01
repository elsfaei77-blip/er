pragma Singleton
import QtQuick

QtObject {
    id: userStore
    
    // Core Profile Data
    property string currentUserName: "shams_design"
    property string currentUserHandle: "shams_design"
    property string currentUserBio: "UI/UX Engineer | Building the future of social 🚀 | Threads Clone Expert"
    property string avatarColor: "#007AFF" // Default brand blue
    
    // Stats
    property int followersCount: 842
    property int followingCount: 156
    property bool isVerified: true

    // Actions
    function updateProfile(name, handle, bio) {
        if (name) currentUserName = name;
        if (handle) currentUserHandle = handle;
        if (bio) currentUserBio = bio;
        console.log("Profile updated:", currentUserName, currentUserHandle);
    }
    
    function updateAvatarColor(color) {
        avatarColor = color;
    }
}
