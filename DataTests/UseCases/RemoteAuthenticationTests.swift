import XCTest
import Domain
import Data

class RemoteAuthenticationTests: XCTestCase {
   
    func test_auth_should_call_httpPostClient_only_once_and_with_correct_url(){
        let url = makeURL()
        let (sut, httpPostClientSpy) = makeSut(url: url)
        sut.auth(authenticationModel: makeAuthenticationModel()) {_ in}
        XCTAssertEqual(httpPostClientSpy.urls, [url])
    }
    
    func test_auth_should_call_httpPostClient_with_correct_data(){
        let authenticationModel = makeAuthenticationModel()
        let (sut, httpPostClientSpy) = makeSut()
        sut.auth(authenticationModel: authenticationModel) { _ in }
        XCTAssertEqual(httpPostClientSpy.data, authenticationModel.toData())
    }
    
    func test_auth_should_complete_with_generic_error_if_client_fails(){
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpPostClientSpy.completeWithError(.noConectivity)
        })
    }
    
    func test_auth_should_complete_with_expiredSession_error_if_client_completes_with_unauthorized(){
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.expiredSession), when: {
            httpPostClientSpy.completeWithError(.unauthorized)
        })
    }
    
    func test_auth_should_complete_with_AccountModel_if_client_succeeds(){
        let (sut, httpPostClientSpy) = makeSut()
        let expectedAccount = makeAccountModel()
        expect(sut, completeWith: .success(expectedAccount), when: {
            httpPostClientSpy.completeWithData(expectedAccount.toData()!)
        })
    }
    
    func test_auth_should_complete_with_generic_error_if_client_completes_with_invalid_data(){
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpPostClientSpy.completeWithData(makeInvalidData())
        })
    }
    
    func test_auth_should_not_complete_if_RemoteAutehntication_has_been_deallocated(){
        let httpPostClientSpy = HttpPostClientSpy()
        var sut: RemoteAuthentication? = RemoteAuthentication(url: makeURL(), httpPostClient: httpPostClientSpy)
        var result: AddAccount.Result?
        sut?.auth(authenticationModel: makeAuthenticationModel()){result = $0}
        sut = nil
        httpPostClientSpy.completeWithError(.noConectivity)
        XCTAssertNil(result)
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
    
    func expect(_ sut: RemoteAuthentication, completeWith expectedResult: Authentication.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) -> Void{
        let exp = expectation(description: "waiting")
        sut.auth(authenticationModel: makeAuthenticationModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default: XCTFail("expect \(expectedResult) but received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
    
}
