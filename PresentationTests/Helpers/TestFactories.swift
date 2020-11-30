import Foundation
import Presentation

func makeSignUpModel(name: String? = "any_name", email: String? = "any_email@email.com", password: String? = "any_password", passwordConfirmation: String? = "any_password") -> SignUpViewModel {
    return SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
}

func makeRequiredFieldAlertViewModelFor(field: String) -> AlertViewModel{
    return AlertViewModel(title: "Required field", message: "\(field) is required")
}

func makeInvalidFieldAlertViewModelFor(field: String) -> AlertViewModel{
    return AlertViewModel(title: "Invalid field", message: "\(field) is invalid")
}

func makeErrorAlertViewModelFor(message: String) -> AlertViewModel{
    return AlertViewModel(title: "Error", message: message)
}

func makeSuccessAlertViewModelFor(message: String) -> AlertViewModel{
    return AlertViewModel(title: "Success", message: message)
}
