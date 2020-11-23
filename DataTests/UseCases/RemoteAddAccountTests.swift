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
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("expected error but received \(result) instead")
            }
            exp.fulfill()
        }
        httpPostClientSpy.completeWithError(.noConectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_AccountModel_if_client_succeeds(){
        let (sut, httpPostClientSpy) = makeSut()
        let expectedAccount = makeAccountModel()
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure: XCTFail("expected success but received \(result) instead")
            case .success(let receivedAccount):  XCTAssertEqual(receivedAccount, expectedAccount)
            }
            exp.fulfill()
        }
        httpPostClientSpy.completeWithData(expectedAccount.toData()!)
        wait(for: [exp], timeout: 1)
    }

}

extension RemoteAddAccountTests {
    
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


