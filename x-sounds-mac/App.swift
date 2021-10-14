import SwiftUI

@main
struct LebkuchenFmSoundsApp: App {
    @AppStorage(AppStorageKeys.showTags.rawValue) var showTags = false
    var body: some Scene {
        WindowGroup {
            SoundsListView()
        }
        .commands {
            CommandGroup(replacing: .toolbar) {
                Toggle("Show tags", isOn: $showTags)
            }
        }
        Settings {
            SettingsView()
        }
    }
}
