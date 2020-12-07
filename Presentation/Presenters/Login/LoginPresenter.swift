import Foundation
import Domain

public final class LoginPresenter {
    private let alertiView: AlertView
    private let validation: Validation
    private let authentication: Authentication
    
    public init(alertiView: AlertView, validation: Validation, authentication: Authentication) {
        self.validation = validation
        self.alertiView = alertiView
        self.authentication = authentication
    }
    
    public func login(viewModel: LoginViewModel) {
        if let message = validation.validate(data: viewModel.toJSON()) {
            alertiView.showMessage(AlertViewModel(title: "Validation failed", message: message))
        } else {
            authentication.auth(authenticationModel: viewModel.toAuthenticationAccountModel()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    var errorMessage: String!
                    switch error {
                    case .expiredSession:
                        errorMessage = "Invalid e-mail or password"
                    default:
                        errorMessage = "An unexpected error occured, please try again later"
                    }
                    self.alertiView.showMessage(AlertViewModel(title: "Error", message: errorMessage))
                case .success: break
                }
            }
        }
    }
}
