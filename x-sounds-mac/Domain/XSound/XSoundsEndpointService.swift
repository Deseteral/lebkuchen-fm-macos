import Combine
import Foundation
import SwiftUI

struct XSoundsEndpointService {
    @AppStorage(AppStorageKeys.fmInstancePath.rawValue) static var instancePath = ""

    static func getSounds(webService: WebServiceProtocol) -> AnyPublisher<[XSound], Error> {
        guard let url = URL(string: instancePath) else {
            return Fail<[XSound], Error>
                .init(error: WebService.Error.invalidURL)
                .eraseToAnyPublisher()
        }
        var request = URLRequest(url: url.appendingPathComponent("x-sounds", isDirectory: true))
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
