import XCTest


class SignUpPresenter {
    private let alertiView: AlertView
    
    init(alertView: AlertView) {
        self.alertiView = alertView
    }
    
    func signUp(viewModel: SignUpViewModel) {
        if let errorMessage = validate(viewModel: viewModel) {
            alertiView.showMessage(AlertViewModel(title: "Validation failed", message: errorMessage))
        }
    }
    
    func validate(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "Name is required"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "Email is required"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "Password is required"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "Password confirmation is required"
        } else if viewModel.password! != viewModel.passwordConfirmation! {
            return "Passwords are not equal"
        }
        return nil
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
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Name is required"))
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() throws {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "felipe", password: "my_password", passwordConfirmation: "my_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Email is required"))
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() throws {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "felipe", email: "felipe@gmail.com", passwordConfirmation: "my_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Password is required"))
    }
    
    func test_signUp_should_show_error_message_if_passwordConfirmation_is_not_provided() throws {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "felipe", email: "felipe@gmail.com", password: "my_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Password confirmation is required"))
    }
    
    func test_signUp_should_show_error_message_if_password_and_passwordConfirmation_does_not_match() throws {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "felipe", email: "felipe@gmail.com", password: "my_password", passwordConfirmation: "my_pass")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Validation failed", message: "Passwords are not equal"))
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
