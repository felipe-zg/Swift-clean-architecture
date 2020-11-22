import Foundation
import Domain

public class RemoteAddAccount{
    private let url: URL
    private let httpPostClient: HttpPostClient
    
    public init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    public func add(addAccountModel: AddAccountModel){
        httpPostClient.post(to: url, with: addAccountModel.toData())
    }
}
