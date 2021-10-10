import SwiftUI
import Combine

struct SoundsListView: View {
    @ObservedObject var viewModel: XSoundsViewModel = XSoundsViewModel()
    @State var searchText: String = ""
    @StateObject private var soundManager = XSoundPlayer()
    @StateObject private var pasteHandler = PasteToSlackHandler()
    var filteredSounds: [XSound] {
        viewModel.sounds.filter {
            searchText.isEmpty ||
                $0.name.localizedStandardContains(searchText)
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
                        HStack {
                            Text(sound.name)
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
}

struct SoundsListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundsListView()
    }
}
