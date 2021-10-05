import SwiftUI

@main
struct x_sounds_macApp: App {
    var body: some Scene {
        WindowGroup {
            SoundsListView()
        }
        Settings {
            SettingsView()
        }
    }
}
