import XCTest


class SignUpPresenter {
    private let alertiView: AlertView
    
    init(alertView: AlertView) {
        self.alertiView = alertView
    }
    
    func signUp(viewModel: SignUpViewModel) {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            alertiView.showMessage(AlertViewModel(title: "Required field", message: "Name is required"))
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            alertiView.showMessage(AlertViewModel(title: "Required field", message: "Email is required"))
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            alertiView.showMessage(AlertViewModel(title: "Required field", message: "Password is required"))
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            alertiView.showMessage(AlertViewModel(title: "Required field", message: "Password confirmation is required"))
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
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(email: "felipe@gamil.com", password: "my_password", passwordConfirmation: "my_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Required field", message: "Name is required"))
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() throws {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "felipe", password: "my_password", passwordConfirmation: "my_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Required field", message: "Email is required"))
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() throws {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "felipe", email: "felipe@gmail.com", passwordConfirmation: "my_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Required field", message: "Password is required"))
    }
    
    func test_signUp_should_show_error_message_if_passwordConfirmation_is_not_provided() throws {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "felipe", email: "felipe@gmail.com", password: "my_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Required field", message: "Password confirmation is required"))
    }
    
}

extension SignUpPresenterTests {
    func makeSut() -> (SignUpPresenter, AlertViewSpy){
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
        return (sut, alertViewSpy)
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessage(_ alertViewModel: AlertViewModel) {
            self.viewModel = alertViewModel
        }
    }
}
