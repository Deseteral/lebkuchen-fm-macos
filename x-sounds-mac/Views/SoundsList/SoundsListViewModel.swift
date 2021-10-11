import Foundation
import Combine

class XSoundsViewModel: ObservableObject {
    @Published private(set) var sounds: [XSound] = []
    private var requestCancellable: AnyCancellable?
    let webService = WebService()
    
    func reload() {
        requestCancellable = XSoundsEndpointService.getSounds(webService: webService)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] value in
                self?.sounds = value
            })
    }
}
