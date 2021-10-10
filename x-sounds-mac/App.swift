import SwiftUI

@main
struct LebkuchenFmSoundsApp: App {
    var body: some Scene {
        WindowGroup {
            SoundsListView()
        }
        Settings {
            SettingsView()
        }
    }
}
