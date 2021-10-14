import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }
    var body: some View {
        TabView {
            RequiredSettingsView()
                .tabItem {
                    Label("Required", systemImage: "gear")
                }
                .tag(Tabs.general)
            AdditionalSettingsView()
                .tabItem {
                    Label("Optional", systemImage: "speaker")
                }
                .tag(Tabs.advanced)
        }
        .padding(20)
        .frame(minWidth: 350, minHeight: 200)
    }
}

struct RequiredSettingsView: View {
    @AppStorage(AppStorageKeys.slackChannelId.rawValue) var slackChannelId = ""
    @AppStorage(AppStorageKeys.slackTeamId.rawValue) var slackTeamId = ""
    @AppStorage(AppStorageKeys.slackCommandEntry.rawValue) var slackCommand = ""
    @AppStorage(AppStorageKeys.fmInstancePath.rawValue) var instancePath = ""


    var body: some View {
        Form {
            TextField("Slack team id", text: $slackTeamId)
            TextField("Slack channel id", text: $slackChannelId)
            TextField("slack command", text: $slackCommand)
            TextField("instance path", text: $instancePath)
        }
        .frame(width: 350)
        .padding(20)
    }
}

struct AdditionalSettingsView: View {
    @AppStorage(AppStorageKeys.relativeVolumeShouldUse.rawValue) var useRelativeVolume = false
    @AppStorage(AppStorageKeys.relativeVolumeValue.rawValue) var relativeVolumeValue = 1.0
    @AppStorage(AppStorageKeys.showTags.rawValue) var showTags = false

    var body: some View {
        Form {
            Section(header: Text("Volume relative to system one")) {
                Toggle("Enabled", isOn: $useRelativeVolume)
                HStack{
                    Text("Multiplier: ")
                    Slider(value: $relativeVolumeValue, in: 0...1.0)
                    Text("(\(relativeVolumeValue*100, specifier: "%.0f")%)")
                }
            }
            Section(header: Text("Show tags")) {
                Toggle("Enabled", isOn: $showTags)
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}
