import UIKit
import Presentation

public class SignUpViewController: UIViewController, Storyboarded {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    public var signUp: ((SignUpViewModel) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        saveButton?.layer.cornerRadius = 5
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        hideKeyboardOnTap()
    }
    
    @objc private func saveButtonTapped() {
        signUp?(SignUpViewModel(name: nameTextField?.text, email: emailTextField?.text, password: passwordTextField?.text, passwordConfirmation: passwordConfirmationTextField?.text))
    }
}

extension SignUpViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        viewModel.isLoading ? load(enableUserInteraction: false, animate: { loadingIndicator.startAnimating() }): load(enableUserInteraction: true, animate: { loadingIndicator.stopAnimating() })
    }
    
    func load(enableUserInteraction: Bool, animate: () -> Void) {
        view.isUserInteractionEnabled = enableUserInteraction
        animate()
    }
}

extension SignUpViewController: AlertView {
    public  func showMessage(_ alertViewModel: AlertViewModel) {
        let alert = UIAlertController(title: alertViewModel.title, message: alertViewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
