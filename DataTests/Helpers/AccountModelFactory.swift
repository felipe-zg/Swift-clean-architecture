import Foundation
import Domain

func makeAccountModel() -> AccountModel{
    return AccountModel(id: "any_id", name: "any_name", email: "any_email", password: "any_password")
}


public func makeAddAccountModel() -> AddAccountModel{
    return AddAccountModel(name: "any_name", email: "any_email@email.com", password: "any_password", passwordConfirmation: "any_password")
}
