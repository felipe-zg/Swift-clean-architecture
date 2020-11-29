import Foundation

public final class SignUpPresenter {
    private  let alertiView: AlertView
    private let emailValidator: EmailValidator
    
    public init(alertView: AlertView, emailValidator: EmailValidator) {
        self.alertiView = alertView
        self.emailValidator = emailValidator
    }
    
    public func signUp(viewModel: SignUpViewModel) {
        if let errorMessage = validate(viewModel: viewModel) {
            alertiView.showMessage(AlertViewModel(title: "Validation failed", message: errorMessage))
        }
    }
    
    func validate(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "Name is required"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "Email is required"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "Password is required"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "Password confirmation is required"
        } else if viewModel.password! != viewModel.passwordConfirmation! {
            return "Passwords are not equal"
        }
        _ = emailValidator.isValid(email: viewModel.email!)
        return nil
    }
}

public struct SignUpViewModel {
    public var name: String?
    public var email: String?
    public var password: String?
    public var passwordConfirmation: String?
    
    public init(name: String? = nil, email: String? = nil, password: String? = nil, passwordConfirmation: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
