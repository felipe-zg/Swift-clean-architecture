import XCTest
import Domain

class RemoteAddAccount{
    private let url: URL
    private let httpPostClient: HttpPostClient
    
    init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    func add(addAccountModel: AddAccountModel){
        httpPostClient.post(to: url, with: addAccountModel.toData())
    }
}

protocol HttpPostClient{
    func post(to url: URL, with data: Data?)
}

class RemoteAddAccountTests: XCTestCase {
   
    func test_add_should_call_httpPostClient_with_correct_url(){
        let url = URL(string: "https://any.url.com/api")!
        let addAccountModel = makeAddAccountModel()
        let (sut, httpPostClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: addAccountModel)
        XCTAssertEqual(httpPostClientSpy.url, url)
    }
    
    func test_add_should_call_httpPostClient_with_correct_data(){
        let addAccountModel = makeAddAccountModel()
        let (sut, httpPostClientSpy) = makeSut()
        sut.add(addAccountModel: addAccountModel)
        XCTAssertEqual(httpPostClientSpy.data, addAccountModel.toData())
    }

}

extension RemoteAddAccountTests {
    
    func makeAddAccountModel() -> AddAccountModel{
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_passoword")
    }
    
    func makeSut(url: URL = URL(string: "https://any.url.com/api")!) -> (sut: RemoteAddAccount, httpPostClientSpy: HttpPostClientSpy) {
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpPostClientSpy)
        return (sut, httpPostClientSpy)
    }
    
    
    class HttpPostClientSpy: HttpPostClient{
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
    
}


