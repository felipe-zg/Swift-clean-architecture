import Foundation
import Domain
import Validation
import Presentation
import UI

public final class SignUpComposer {
    public static func composeControllerWith(addAccount: AddAccount) -> SignUpViewController{
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let presenter = SignUpPresenter(alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), emailValidator: emailValidatorAdapter, addAccount: addAccount)
        controller.signUp = presenter.signUp
        return controller
    }
}
