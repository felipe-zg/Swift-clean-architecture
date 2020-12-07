import Foundation
import Domain

public final class LoginPresenter {
    private let alertiView: AlertView
    private let validation: Validation
    
    public init(alertiView: AlertView, validation: Validation) {
        self.validation = validation
        self.alertiView = alertiView
    }
    
    public func login(viewModel: LoginViewModel) {
        if let message = validation.validate(data: viewModel.toJSON()) {
            alertiView.showMessage(AlertViewModel(title: "Validation failed", message: message))
        }
    }
}
