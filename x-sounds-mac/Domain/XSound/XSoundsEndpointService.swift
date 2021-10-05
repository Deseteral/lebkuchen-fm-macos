import Combine
import Foundation
import SwiftUI

struct XSoundsEndpointService {
    @AppStorage(AppStorageKeys.FMinstancePath.rawValue) static var instancePath = ""
    
    struct URLCreatingError: Error { }
    
    static func getSounds(webService: WebServiceProtocol) -> AnyPublisher<[XSound], Error> {
        let urlString = instancePath + "x-sounds"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "Get"
        let resource = WebResource<Response>(request: request)
        return webService.load(resource: resource)
            .map { response in
                return response.sounds
            }
            .eraseToAnyPublisher()
    }
    
    private struct Response: Decodable {
        let sounds: [XSound]
    }
    
    private struct LoginRequestBody: Encodable {
        let email: String
        let password: String
    }
    
    private init() {}
}
