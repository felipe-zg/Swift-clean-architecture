import Foundation
import UI
import Validation
import Infra
import Data
import Presentation

class SignUpFactory {
    static func makeController() -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidatorAdapter = EmailValidatorAdapter()
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://clean-node-api.herokuapp.com/api/signup")!
        let remoteAddAccount = RemoteAddAccount(url: url, httpPostClient: alamofireAdapter)
        let presenter = SignUpPresenter(alertView: controller, loadingView: controller, emailValidator: emailValidatorAdapter, addAccount: remoteAddAccount)
        controller.signUp = presenter.signUp
        return controller
    }
}
