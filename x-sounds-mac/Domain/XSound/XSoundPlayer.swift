import AVKit
import Foundation
import SwiftUI

final class XSoundPlayer : ObservableObject {
    @Published private(set) var playing: String? = nil
    @Published private(set) var failed: Set<String> = []
    
    @AppStorage(AppStorageKeys.relativeVolumeShouldUse.rawValue) var useRelativeVolume = false
    @AppStorage(AppStorageKeys.relativeVolumeValue.rawValue) var relativeVolumeValue = 1.0
    private var audioPlayer: AVPlayer?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func playSound(sound: URL, id: String) {
        self.audioPlayer?.pause()
        guard playing != id else {
            self.audioPlayer?.pause()
            playing = nil
            return
        }
        
        NotificationCenter.default.removeObserver(self)
        self.audioPlayer = AVPlayer(url: sound)
        if useRelativeVolume {
            self.audioPlayer?.volume = Float(relativeVolumeValue)
        }
        
        self.audioPlayer?.play()
        playing = id
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidPlayToEndTime),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.audioPlayer?.currentItem)
        if !AVAsset(url: sound).isPlayable {
            failed.insert(id)
        } else {
            failed.remove(id)
        }
    }
    
    @objc func playerItemDidPlayToEndTime() {
        playing = nil
    }
}
