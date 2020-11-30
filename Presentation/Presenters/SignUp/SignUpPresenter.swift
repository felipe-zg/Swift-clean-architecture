import Foundation
import Domain

public final class SignUpPresenter {
    private  let alertiView: AlertView
    private let loadingView: LoadingView
    private let emailValidator: EmailValidator
    private let addAccount: AddAccount
    
    public init(alertView: AlertView, loadingView: LoadingView, emailValidator: EmailValidator, addAccount: AddAccount) {
        self.alertiView = alertView
        self.loadingView = loadingView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
    }
    
    public func signUp(viewModel: SignUpViewModel) {
        if let alertModel = validate(viewModel: viewModel) {
            alertiView.showMessage(alertModel)
        } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: SignUpMapper.toAddAccountModel(viewModel: viewModel)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure: self.alertiView.showMessage(AlertViewModel(title: "Error", message: "An unexpected error occured, please try again later"))
                case .success: self.alertiView.showMessage(AlertViewModel(title: "Success", message: "Account has been created successfully"))
                }
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
            }
        }
    }
    
    func validate(viewModel: SignUpViewModel) -> AlertViewModel? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return makeRequiredFieldAlertViewModelFor(field: "Name")
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return makeRequiredFieldAlertViewModelFor(field: "Email")
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return makeRequiredFieldAlertViewModelFor(field: "Password")
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return makeRequiredFieldAlertViewModelFor(field: "Password confirmation")
        } else if viewModel.password! != viewModel.passwordConfirmation! {
            return makeInvalidFieldAlertViewModelFor(field: "Password confirmation")
        } else if !emailValidator.isValid(email: viewModel.email!){
            return makeInvalidFieldAlertViewModelFor(field: "Email")
        }
        return nil
    }
    
    func makeRequiredFieldAlertViewModelFor(field: String) -> AlertViewModel{
        return AlertViewModel(title: "Required field", message: "\(field) is required")
    }
    
    func makeInvalidFieldAlertViewModelFor(field: String) -> AlertViewModel{
        return AlertViewModel(title: "Invalid field", message: "\(field) is invalid")
    }
}