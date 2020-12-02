import Foundation
import Domain
import UI
import Validation
import Infra
import Data
import Presentation

class ControllerFactory {
    static func makeSignUp(addAccount: AddAccount) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let presenter = SignUpPresenter(alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), emailValidator: emailValidatorAdapter, addAccount: addAccount)
        controller.signUp = presenter.signUp
        return controller
    }
}
