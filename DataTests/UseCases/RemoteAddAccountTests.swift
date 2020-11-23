import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
   
    func test_add_should_call_httpPostClient_only_once_and_with_correct_url(){
        let url = URL(string: "https://any.url.com/api")!
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
    
    func test_add_should_complete_with_DomainError_if_client_fails(){
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpPostClientSpy.completeWithError(.noConectivity)
        })
    }
    
    func test_add_should_complete_with_AccountModel_if_client_succeeds(){
        let (sut, httpPostClientSpy) = makeSut()
        let expectedAccount = makeAccountModel()
        expect(sut, completeWith: .success(expectedAccount), when: {
            httpPostClientSpy.completeWithData(expectedAccount.toData()!)
        })
    }
    
    func test_add_should_complete_with_DomainError_if_client_completes_with_invalid_data(){
        let (sut, httpPostClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpPostClientSpy.completeWithData(Data("invalid_data".utf8))
        })
    }

}

extension RemoteAddAccountTests {
    
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) -> Void{
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
    
    func makeAddAccountModel() -> AddAccountModel{
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_passoword")
    }

    func makeAccountModel() -> AccountModel{
        return AccountModel(id: "any_id", name: "any_name", email: "any_email", password: "any_password")
    }
    
    func makeSut(url: URL = URL(string: "https://any.url.com/api")!) -> (sut: RemoteAddAccount, httpPostClientSpy: HttpPostClientSpy) {
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        return (sut, httpPostClientSpy)
    }
    
    
    class HttpPostClientSpy: HttpPostClient{
        var urls = [URL]()
        var data: Data?
        var completion: ((Result<Data, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError){
            completion?(.failure(error))
        }
        
        func completeWithData(_ data: Data){
            completion?(.success(data))
        }
    }
    
}


