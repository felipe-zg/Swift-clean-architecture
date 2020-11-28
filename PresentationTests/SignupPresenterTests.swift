import XCTest


class SignUpPresenter {
    private let alertiView: AlertView
    
    init(alertView: AlertView) {
        self.alertiView = alertView
    }
    
    func signUp(viewModel: SignUpViewModel) {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            alertiView.showMessage(AlertViewModel(title: "Required field", message: "Name is required"))
        }
    }
}

protocol AlertView {
    func showMessage(_ alertViewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    let title: String
    let message: String
}

struct SignUpViewModel {
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirmation: String?
}

class SignUpPresenterTests: XCTestCase {
    func test_signUp_should_show_error_message_if_name_is_not_provided() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(email: "felipe", password: "my_password", passwordConfirmation: "my_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Required field", message: "Name is required"))
    }
}

extension SignUpPresenterTests {
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessage(_ alertViewModel: AlertViewModel) {
            self.viewModel = alertViewModel
        }
    }
}
