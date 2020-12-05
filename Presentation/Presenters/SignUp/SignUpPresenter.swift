import Foundation
import Domain

public final class SignUpPresenter {
    private  let alertiView: AlertView
    private let loadingView: LoadingView
    private let validation: Validation
    private let addAccount: AddAccount
    
    public init(alertView: AlertView, loadingView: LoadingView, validation: Validation, addAccount: AddAccount) {
        self.alertiView = alertView
        self.loadingView = loadingView
        self.validation = validation
        self.addAccount = addAccount
    }
    
    public func signUp(viewModel: SignUpViewModel) {
            if let message = validation.validate(data: viewModel.toJSON()) {
                alertiView.showMessage(AlertViewModel(title: "Falha na validação", message: message))
            } else {
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            addAccount.add(addAccountModel: SignUpMapper.toAddAccountModel(viewModel: viewModel)) { [weak self] result in
                guard let self = self else { return }
                self.loadingView.display(viewModel: LoadingViewModel(isLoading: false))
                switch result {
                case .failure: self.alertiView.showMessage(AlertViewModel(title: "Error", message: "An unexpected error occured, please try again later"))
                case .success: self.alertiView.showMessage(AlertViewModel(title: "Success", message: "Account has been created successfully"))
                }
            }
        }
    }
}
