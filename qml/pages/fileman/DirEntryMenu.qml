import Mer.Cutes 1.1
import QtQuick 2.0
import Sailfish.Silica 1.0
import "Bridge.js" as Util

ContextMenu {
    id : entryMenu

    property string fileName: ""
    property string fileType: ""
    property string fileInfo: ""
    property string filePath: ""
    signal mediaFileOpen(string url)

    onVisibleChanged: {
        if (visible) {
            Util.getFileType(filePath, fileType, function(v) {
                fileInfo = v;
            });
        }
    }

    function openFile() {
        var url = "file://" + filePath;
        //console.log("Open clicked");
        mediaFileOpen(url);
        pageStack.push(dataContainer)

        //Qt.openUrlExternally(url);
    }

    // Seems to work but Util.rm seems to fail somehow
    function deleteFile() {
        var fullName = filePath;
        var msg = "Deleting " + fileName;
        // function executed as a remorse action does not capture context :(
        // so, save needed functions as locals
        var rmFile = Util.rm;
        var rmItem = entries.remove;
        var pos = index;
        var action = function() {
            rmFile(fullName);
            rmItem(pos);
        };
        remorseAction(msg, action, 3000);
    }

    function storePath() {
        Util.pathStore({path: root
                        , name: fileName
                        , fileType: fileType});
    }

    TextArea {
        anchors { left: parent.left; right: parent.right }
        wrapMode: TextEdit.WordWrap
        font.pixelSize: Theme.fontSizeExtraSmall
        readOnly: true
        text: entryMenu.fileInfo
    }
    MenuItem {
        text: "Open"
        onClicked :  entryMenu.openFile()
    }
//    MenuItem {
//        text: "Delete"
//        onClicked: entryMenu.deleteFile()
//    }
//    MenuItem {
//        text: "Mark"
//        onClicked: entryMenu.storePath()
//    }
}
