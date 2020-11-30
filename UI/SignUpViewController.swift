import UIKit
import Presentation

class SignUpViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension SignUpViewController: LoadingView {
    func display(viewModel: LoadingViewModel) {
        viewModel.isLoading ? loadingIndicator.startAnimating(): loadingIndicator.stopAnimating()
    }
}
