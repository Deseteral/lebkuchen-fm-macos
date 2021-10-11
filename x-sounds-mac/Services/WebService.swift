import Foundation
import Combine

protocol WebServiceProtocol {
    func load<T: Decodable>(resource: WebResource<T>) -> AnyPublisher<T, Swift.Error>
}

final class WebService: WebServiceProtocol {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    enum Error: Swift.Error {
        case invalidResponse
        case httpError(Int)
        case invalidData
        case terminated
        case invalidURL
    }

    func load<T: Decodable>(resource: WebResource<T>) -> AnyPublisher<T, Swift.Error> {
        return load(request: resource.request)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func load(request: URLRequest) -> AnyPublisher<Data, Swift.Error> {
        // TODO: Remove when logger in place
        debugPrint("Loading request with url: \(request.url!.absoluteString)")
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw Error.invalidResponse
                }
                guard 200..<400 ~= httpResponse.statusCode else {
                    throw Error.httpError(httpResponse.statusCode)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}

struct WebResource<T: Decodable> {
    let request: URLRequest
}
