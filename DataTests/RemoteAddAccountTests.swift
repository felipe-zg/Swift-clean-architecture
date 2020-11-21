import XCTest

class RemoteAddAccount{
    private let url: URL
    private let httpPostClient: HttpPostClient
    
    init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    func add(){
        httpPostClient.post(url: url)
    }
}

protocol HttpPostClient{
    func post(url: URL)
}

class RemoteAddAccountTests: XCTestCase {
   
    func test_add_should_call_httpPostClient_with_correct_url(){
        let myUrl = URL(string: "https://any.url.com/api")!
        let httpPostClientSpy = HttpPostClientSpy()
        let sut = RemoteAddAccount(url: myUrl, httpPostClient: httpPostClientSpy)
        sut.add()
        XCTAssertEqual(httpPostClientSpy.url, myUrl)
    }

}

class HttpPostClientSpy: HttpPostClient{
    var url: URL?
    
    func post(url: URL) {
        self.url = url
    }
}
