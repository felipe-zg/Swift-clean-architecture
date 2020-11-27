import XCTest
import Alamofire
import Data

class AlamofireAdapter{
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void){
        session.request(url, method: .post, parameters: data?.toJSON(), encoding: JSONEncoding.default).responseData { (dataResponse) in
            guard let statusCode = dataResponse.response?.statusCode else {
                return completion(.failure(.noConectivity))
            }
            switch dataResponse.result {
            case .failure: completion(.failure(.noConectivity))
            case .success(let data):
                switch statusCode {
                case 200:
                    completion(.success(data))
                case 401:
                    completion(.failure(.unauthorized))
                case 403:
                    completion(.failure(.forbidden))
                case 400...499:
                    completion(.failure(.badRequest))
                case 500...599:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.noConectivity))
                }
            }
        }
    }
}

class AlamofireAdapterTests: XCTestCase {
    func test_post_should_call_Alamofire_with_correct_url_and_data() throws {
        let url = makeURL()
        testRequestFor(url: url, data: makeValidData()) { (request) in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    func test_post_can_call_Alamofire_with_no_data() throws {
        testRequestFor(data: nil) { (request) in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_complete_with_error_when_request_completes_with_error() throws {
        expectResult(.failure(.noConectivity), when: (data: nil, response: nil, error: makeError())   )
    }
    
    func test_post_should_complete_with_error_on_all_invalid_cases() throws {
        expectResult(.failure(.noConectivity), when: (data: makeValidData(), response: makeHttpResponse(), error: makeError())   )
        expectResult(.failure(.noConectivity), when: (data: makeValidData(), response: nil, error: makeError())   )
        expectResult(.failure(.noConectivity), when: (data: makeValidData(), response: nil, error: nil)   )
        expectResult(.failure(.noConectivity), when: (data: nil, response: makeHttpResponse(), error: makeError())   )
        expectResult(.failure(.noConectivity), when: (data: nil, response: makeHttpResponse(), error: nil)   )
        expectResult(.failure(.noConectivity), when: (data: nil, response: nil, error: nil)   )
    }
    
    func test_post_should_complete_with_error_when_request_completes_with_non_200() throws {
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 400), error: nil)   )
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 450), error: nil)   )
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 499), error: nil)   )
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 500), error: nil)   )
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 550), error: nil)   )
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 599), error: nil)   )
        expectResult(.failure(.unauthorized), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 401), error: nil)   )
        expectResult(.failure(.forbidden), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 403), error: nil)   )
    }
    
    func test_post_should_complete_with_data_when_request_completes_with_200() throws {
        expectResult(.success(makeValidData()), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 200), error: nil)   )
    }
}

extension AlamofireAdapterTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func testRequestFor(url: URL = makeURL(), data: Data?, action: @escaping (URLRequest) -> Void) {
        // changed this method after creating the latest test to wait for the post completion handler to execute and avoid data racing
        let sut = makeSut()
        let exp = expectation(description: "waiting tests")
        sut.post(to: url, with: data) {_ in exp.fulfill()}
        var request: URLRequest?
        UrlProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    func expectResult(_ expectedResult: Result<Data, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?),  file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSut()
        UrlProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting test")
        sut.post(to: makeURL(), with: makeValidData()) { (receivedResult) in
            switch(expectedResult, receivedResult){
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedData), .success(let receivedData)): XCTAssertEqual(expectedData, receivedData, file: file, line: line)
            default: XCTFail("expected \(expectedResult) but received \(receivedResult)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static var data: Data?
    static var response: HTTPURLResponse?
    static var error: Error?
    
    static func observeRequest(completion: @escaping (URLRequest) -> Void){
        self.emit = completion
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?){
        UrlProtocolStub.data = data
        UrlProtocolStub.response = response
        UrlProtocolStub.error = error
    }
    
    override func startLoading() {
        UrlProtocolStub.emit?(request)
        if let data = UrlProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = UrlProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let error = UrlProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
    
}

