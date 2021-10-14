import SwiftUI
import Combine

struct SoundsListView: View {
    @ObservedObject var viewModel: XSoundsViewModel = XSoundsViewModel()
    @State var searchText: String = ""
    @StateObject private var soundManager = XSoundPlayer()
    @StateObject private var pasteHandler = PasteToSlackHandler()
    @AppStorage(AppStorageKeys.showTags.rawValue) var showTags = false

    var filteredSounds: [XSound] {
        viewModel.sounds.filter { sound in
            let searchWords = Set(searchText.split(separator: " ").map { String($0) })
            let tagsAndNameJoinedString = sound.name.appending(sound.tags?.joined(separator: " ") ?? "")
            let allWordsFromSearchTextInTagsOrName = searchWords.allSatisfy(tagsAndNameJoinedString.localizedCaseInsensitiveContains)
            return allWordsFromSearchTextInTagsOrName
        }
    }

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText)
                    .cornerRadius(8)
                    .padding()
                Button(action: {
                    viewModel.reload()
                }, label: {
                    Text("Fetch XSounds list")
                })
            }.padding(.trailing)
            
            List {
                Section(header: HStack {
                    Text("name")
                    Spacer()
                    Text("copy").frame(width: 50)
                    Text("preview").frame(width: 50)
                }) {
                    ForEach(filteredSounds, id: \.id ) { sound in
                        soundRow(sound)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .padding(.bottom)
        }
        .frame(minWidth: 300, minHeight: 300)
        .onAppear() {
            viewModel.reload()
        }
    }
    
    func soundTapped(sound: XSound) {
        pasteHandler.paste(text: "/fm x \(sound.name)")
    }

    @ViewBuilder func soundRow(_ sound: XSound) -> some View {
        let tags = sound.tags?.joined(separator: ", ")
        HStack {
            Text(sound.name)
                .font(.callout)
                .foregroundColor(.primary)
            if let tags = tags, !tags.isEmpty, showTags {
                Text("(\(tags))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if soundManager.failed.contains(sound.id) {
                Image(systemName: "xmark.octagon")
            }
            Button(action: {
                soundTapped(sound: sound)
            }, label: {
                Image(systemName: "doc.on.doc")
            }).frame(width: 50)
            Button(action: {
                soundManager.playSound(sound: sound.url, id: sound.id)
            }, label: {
                Image(systemName: soundManager.playing == sound.id ? "pause" : "play")
            }).frame(width: 50)
        }
    }
}

struct SoundsListView_Previews: PreviewProvider {
    final class ViewModelMock: XSoundsViewModel {
        override var sounds: [XSound] {
            (1...10).map { i in
                XSound(
                    id: String(i),
                    name: "Name_\(i)",
                    url: URL(string: "www.example.com")!,
                    timesPlayed: 0,
                    tags: Array((0...2).map {"tag\($0)"}.prefix(Int.random(in: 0...2)))
                )
            }
        }
    }
    
    static var previews: some View {
        SoundsListView(viewModel: ViewModelMock(), searchText: "")
    }
}
