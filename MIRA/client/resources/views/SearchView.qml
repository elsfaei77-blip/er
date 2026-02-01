import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../components"
import "../"

Item {
    Rectangle {
        anchors.fill: parent
        color: Constants.background
    }
    
    Connections {
        target: NetworkManager
        function onSearchResultsReceived(users, posts) {
            resultsModel.clear()
            for(var i=0; i<users.length; i++) {
                users[i].type = "user"
                resultsModel.append(users[i])
            }
             for(var j=0; j<posts.length; j++) {
                posts[j].type = "post"
                resultsModel.append(posts[j])
            }
        }
    }
    
    ListModel { id: resultsModel }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15
        
        // Search Bar
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: Constants.surfaceHighlight
            radius: 10
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                Icon { pathData: Icons.search; color: Constants.textSecondary; width: 16; height: 16 }
                
                TextInput {
                    Layout.fillWidth: true
                    color: Constants.textPrimary
                    text: "Search..."
                    font.pixelSize: 16
                    selectByMouse: true
                    onAccepted: NetworkManager.search(text)
                }
            }
        }
        
        // Results
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: resultsModel
            
            delegate: Item {
                width: parent.width
                height: 60
                
                RowLayout {
                    anchors.fill: parent
                    spacing: 10
                    
                    RoundImage {
                        size: 40
                        source: model.avatar || ""
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        Text {
                            text: model.type === "user" ? model.username : model.content
                            color: Constants.textPrimary
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        Text {
                            text: model.type === "user" ? "User" : "Post by " + model.username
                            color: Constants.textSecondary
                            font.pixelSize: 12
                        }
                    }
                    
                    // Follow Button (Only for users)
                    StyledButton {
                        visible: model.type === "user"
                        textContent: "Follow" // Should check if following
                        width: 80
                        height: 30
                        
                        onClicked: {
                            NetworkManager.toggleFollow(model.id)
                            textContent = textContent === "Follow" ? "Following" : "Follow"
                        }
                    }
                }
            }
        }
    }
}
