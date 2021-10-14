import Foundation

struct XSound: Codable, Identifiable {
    let id: String
    let name: String
    let url: URL
    let timesPlayed: Int
    let tags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id", name, url, timesPlayed, tags
    }
}
