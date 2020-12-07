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
            guard self != nil else {return}
            let _ = self?.url
            switch result {
            case .failure(let error):
                switch error {
                case .unauthorized:
                    completion(.failure(.expiredSession))
                default:
                    completion(.failure(.unexpected))
                }
            case .success(let data):
                if let model: AccountModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            }
        }
    }
}
