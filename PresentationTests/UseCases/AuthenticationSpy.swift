import Foundation
import Presentation
import Domain

class AuthenticationSpy: Authentication {
    var authenticationModel: AuthenticationModel?
    var completion: ((Authentication.Result) -> Void)?
    
    func auth(authenticationModel: AuthenticationModel, completion: @escaping (Authentication.Result) -> Void) {
        self.authenticationModel = authenticationModel
        self.completion = completion
    }
    
    func completeWithError(_ error: DomainError) -> Void {
        completion?(.failure(error))
    }
    
    func completeWithSuccess(_ accountModel: AccountModel) -> Void {
        completion?(.success(accountModel))
    }
}
