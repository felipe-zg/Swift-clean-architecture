import Foundation
import Domain

public class RemoteAddAccount{
    private let url: URL
    private let httpPostClient: HttpPostClient
    
    public init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void){
        httpPostClient.post(to: url, with: addAccountModel.toData()) { result in
            switch result {
            case .failure:  completion(.failure(.unexpected))
            case .success(let data):
                if let model: AccountModel = data.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            }
        }
    }
}
