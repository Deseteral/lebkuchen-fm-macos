import SwiftUI

final class PasteToSlackHandler : ObservableObject {
    private var valueToPaste: String? = nil
    private let notificationName = NSWorkspace.didActivateApplicationNotification
    @AppStorage(AppStorageKeys.slackChanelId.rawValue) var slackChanelId = ""
    @AppStorage(AppStorageKeys.slackTeamId.rawValue) var slackTeamId = ""
    
    init() {
        NSWorkspace.shared.notificationCenter
            .addObserver(self,
                         selector: #selector(didActivateApplicationNotification(_:)),
                         name: notificationName,
                         object:nil)
    }
    
    deinit {
        NSWorkspace.shared.notificationCenter
            .removeObserver(self, name: notificationName, object: nil)
    }
    
    func paste(text:String) {
        valueToPaste = text
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(text, forType: .string)
        let url = URL(string: "slack://channel?team=\(slackTeamId)&id=\(slackChanelId)")!
        NSWorkspace.shared.open(url)
    }
    
    @objc private func didActivateApplicationNotification(_ notification: NSNotification) {
        let app = notification.userInfo!["NSWorkspaceApplicationKey"] as? NSRunningApplication
        let activeApp = app?.localizedName
        
        guard activeApp == "Slack", valueToPaste != nil else { return }
        sleep(1)
        simulatePasteShortcut()
        valueToPaste = nil
    }
    
    private func simulatePasteShortcut() {
        let keyVDown = CGEvent(keyboardEventSource: nil, virtualKey: 0x9, keyDown: true)
        let keyVUp = CGEvent(keyboardEventSource: nil, virtualKey: 0x9, keyDown: false)
        keyVDown?.flags = .maskCommand // hold cmd when tapping v
        keyVDown?.post(tap: .cghidEventTap)
        keyVUp?.post(tap: .cghidEventTap)
    }
}
