import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
   
    func test_add_should_call_httpPostClient_only_once_and_with_correct_url(){
        let url = makeURL()
        let addAccountModel = makeAddAccountModel()
        let (sut, httpPostClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: addAccountModel) {_ in}
        XCTAssertEqual(httpPostClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpPostClient_with_correct_data(){
        let addAccountModel = makeAddAccountModel()
        let (sut, httpPostClientSpy) = makeSut()
        sut.add(addAccountModel: addAccountModel) {_ in}
        XCTAssertEqual(httpPostClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_should_complete_with_generic_error_if_client_fails(){
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpPostClientSpy.completeWithError(.noConectivity)
        })
    }
    
    func test_add_should_complete_with_email_in_use_error_if_client_completes_with_forbidden(){
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.emailInUse), when: {
            httpPostClientSpy.completeWithError(.forbidden)
        })
    }
    
    func test_add_should_complete_with_AccountModel_if_client_succeeds(){
        let (sut, httpPostClientSpy) = makeSut()
        let expectedAccount = makeAccountModel()
        expect(sut, completeWith: .success(expectedAccount), when: {
            httpPostClientSpy.completeWithData(expectedAccount.toData()!)
        })
    }
    
    func test_add_should_complete_with_generic_error_if_client_completes_with_invalid_data(){
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpPostClientSpy.completeWithData(makeInvalidData())
        })
    }
    
    func test_add_should_not_complete_if_RemoteAddAccount_has_been_deallocated(){
        let httpPostClientSpy = HttpPostClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeURL(), httpPostClient: httpPostClientSpy)
        var result: AddAccount.Result?
        sut?.add(addAccountModel: makeAddAccountModel()){ result = $0 }
        sut = nil
        httpPostClientSpy.completeWithError(.noConectivity)
        XCTAssertNil(result)
    }
}

extension RemoteAddAccountTests {
    
    func makeSut(url: URL = URL(string: "https://any.url.com/api")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteAddAccount, httpPostClientSpy: HttpPostClientSpy) {
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpPostClientSpy, file: file, line: line)
        return (sut, httpPostClientSpy)
    }
    
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: AddAccount.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) -> Void{
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
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


