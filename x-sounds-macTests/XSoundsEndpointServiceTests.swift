import XCTest
import Combine
@testable import x_sounds_mac

final class XSoundsEndpointServiceTests: XCTestCase {

    func testGetSounds_ShouldCreateCorrectUrlRequest() throws {
        // Given
        let webServiceMock = WebServiceMock()
        XSoundsEndpointService.instancePath = "test"

        // When
        _ = XSoundsEndpointService.getSounds(webService: webServiceMock)

        // Then
        XCTAssertEqual(webServiceMock.receivedRequest?.url, URL(string: "test/x-sounds"))
        XCTAssertEqual(webServiceMock.receivedRequest?.httpMethod, "GET")
    }

    func testGetSounds_ShouldFail_WhenInstancePathIsNotCorrect() throws {
        // Given
        let webServiceMock = WebServiceMock()
        XSoundsEndpointService.instancePath = "###"

        // When
        let result = try? testPublisher(XSoundsEndpointService.getSounds(webService: webServiceMock))

        // Then
        guard case .failure(let error) = result else {
            return XCTFail("Expected to be a failure but got a success")
        }
        guard case WebService.Error.invalidURL = error else {
            return XCTFail("Expected to be `invalidURL` error")
        }
        XCTAssertEqual(webServiceMock.receivedRequest, nil)
    }
}

final class WebServiceMock: WebServiceProtocol {
    struct WebServiceMockedError: Error {}
    var receivedRequest: URLRequest?

    func load<T>(resource: WebResource<T>) -> AnyPublisher<T, Error> where T : Decodable {
        receivedRequest = resource.request
        return Fail.init(error: WebServiceMockedError()).eraseToAnyPublisher()
    }
}
