import XCTest
import Domain
import Data

class RemoteAuthenticationTests: XCTestCase {
   
    func test_auth_should_call_httpPostClient_only_once_and_with_correct_url(){
        let url = makeURL()
        let authenticationModel = makeAuthenticationModel()
        let (sut, httpPostClientSpy) = makeSut(url: url)
        sut.auth(authenticationModel: makeAuthenticationModel()) {_ in}
        XCTAssertEqual(httpPostClientSpy.urls, [url])
    }
}

extension RemoteAuthenticationTests {
    
    func makeSut(url: URL = URL(string: "https://any.url.com/api")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteAuthentication, httpPostClientSpy: HttpPostClientSpy) {
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAuthentication(url: url, httpPostClient: httpPostClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpPostClientSpy, file: file, line: line)
        return (sut, httpPostClientSpy)
    }
    
}
