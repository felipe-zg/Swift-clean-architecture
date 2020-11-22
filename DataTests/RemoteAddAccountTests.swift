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
        let data = try? JSONEncoder().encode(addAccountModel)
        httpPostClient.post(to: url, with: data)
    }
}

protocol HttpPostClient{
    func post(to url: URL, with data: Data?)
}

class RemoteAddAccountTests: XCTestCase {
   
    func test_add_should_call_httpPostClient_with_correct_url(){
        let myUrl = URL(string: "https://any.url.com/api")!
        let httpPostClientSpy = HttpPostClientSpy()
        let addAccountModel = makeAddAccountModel()
        let sut = RemoteAddAccount(url: myUrl, httpPostClient: httpPostClientSpy)
        sut.add(addAccountModel: addAccountModel)
        XCTAssertEqual(httpPostClientSpy.url, myUrl)
    }
    
    func test_add_should_call_httpPostClient_with_correct_data(){
        let httpPostClientSpy = HttpPostClientSpy()
        let addAccountModel = makeAddAccountModel()
        let sut = RemoteAddAccount(url: URL(string: "https://any.url.com/api")!, httpPostClient: httpPostClientSpy)
        sut.add(addAccountModel: addAccountModel)
        let data = try? JSONEncoder().encode(addAccountModel)
        XCTAssertEqual(httpPostClientSpy.data, data)
    }

}

extension RemoteAddAccountTests {
    
    func makeAddAccountModel() -> AddAccountModel{
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_passoword")
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


