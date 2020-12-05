import Foundation
import Presentation
import Domain

class AddAccountSpy: AddAccount {
    var addAccountModel: AddAccountModel?
    var completion: ((AddAccount.Result) -> Void)?
    
    func add(addAccountModel: AddAccountModel, completion: @escaping (AddAccount.Result) -> Void) {
        self.addAccountModel = addAccountModel
        self.completion = completion
    }
    
    func completeWithError(_ error: DomainError) -> Void {
        completion?(.failure(error))
    }
    
    func completeWithSuccess(_ accountModel: AccountModel) -> Void {
        completion?(.success(accountModel))
    }
}
