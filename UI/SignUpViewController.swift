import UIKit
import Presentation

class SignUpViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    var signUp: ((SignUpViewModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        signUp?(SignUpViewModel(name: nameTextField?.text, email: emailTextField?.text, password: passwordTextField?.text, passwordConfirmation: passwordConfirmationTextField?.text))
    }
}

extension SignUpViewController: LoadingView {
    func display(viewModel: LoadingViewModel) {
        viewModel.isLoading ? loadingIndicator.startAnimating(): loadingIndicator.stopAnimating()
    }
}

extension SignUpViewController: AlertView {
    func showMessage(_ alertViewModel: AlertViewModel) {
        
    }
}
