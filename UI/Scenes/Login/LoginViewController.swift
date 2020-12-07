import UIKit
import Presentation

public class LoginViewController: UIViewController, Storyboarded {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    public var login: ((LoginViewModel) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        configure()
    }
    
    private func configure() {
        loginButton?.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        hideKeyboardOnTap()
    }
    
    @objc private func loginButtonTapped() {
        login?(LoginViewModel(email: emailTextField?.text, password: passwordTextField?.text))
    }
}

