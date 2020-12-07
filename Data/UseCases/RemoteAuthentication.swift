import Foundation
import Domain

public class RemoteAuthentication{
    private let url: URL
    private let httpPostClient: HttpPostClient
    
    public init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    public func auth(authenticationModel: AuthenticationModel, completion: @escaping (Authentication.Result) -> Void){
        httpPostClient.post(to: url, with: authenticationModel.toData()) { [weak self] result in
            
        }
    }
}
