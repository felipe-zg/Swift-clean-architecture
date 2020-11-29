import XCTest
import Presentation
import Domain
import Data

class SignUpPresenterTests: XCTestCase {
    func test_signUp_should_show_error_message_if_name_is_not_provided() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe { [weak self] (alertViewModel) in
            XCTAssertEqual(alertViewModel, self?.makeRequiredFieldAlertViewModelFor(field: "Name"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpModel(name: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_email_is_not_provided() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe { [weak self] (alertViewModel) in
            XCTAssertEqual(alertViewModel, self?.makeRequiredFieldAlertViewModelFor(field: "Email"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpModel(email: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_is_not_provided() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe { [weak self] (alertViewModel) in
            XCTAssertEqual(alertViewModel, self?.makeRequiredFieldAlertViewModelFor(field: "Password"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpModel(password: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_passwordConfirmation_is_not_provided() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe { [weak self] (alertViewModel) in
            XCTAssertEqual(alertViewModel, self?.makeRequiredFieldAlertViewModelFor(field: "Password confirmation"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpModel(passwordConfirmation: nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_error_message_if_password_and_passwordConfirmation_does_not_match() throws {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe { [weak self] (alertViewModel) in
            XCTAssertEqual(alertViewModel, self?.makeInvalidFieldAlertViewModelFor(field: "Password confirmation"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpModel(passwordConfirmation: "wrong_password"))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_call_emailValidator_withCorrect_email() throws {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(name: "felipe", email: "invalid@email.com", password: "my_password", passwordConfirmation: "my_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signUp_should_show_error_message_if_email_is_invalid() throws {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe { [weak self] (alertViewModel) in
            XCTAssertEqual(alertViewModel, self?.makeInvalidFieldAlertViewModelFor(field: "Email"))
            exp.fulfill()
        }
        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: makeSignUpModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_call_addAccount_with_correct_values() throws {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(viewModel: makeSignUpModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }
    
    func test_signUp_should_show_error_message_if_addAccount_fails() throws {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe { [weak self] (alertViewModel) in
            XCTAssertEqual(alertViewModel, self?.makeErrorAlertViewModelFor(message: "An unexpected error occured, please try again later"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
}

extension SignUpPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy(), addAccount: AddAccountSpy = AddAccountSpy()) -> SignUpPresenter{
        let sut = SignUpPresenter(alertView: alertView, emailValidator: emailValidator, addAccount: addAccount)
        return sut
    }
    
    func makeSignUpModel(name: String? = "any_name", email: String? = "any_email@email.com", password: String? = "any_password", passwordConfirmation: String? = "any_password") -> SignUpViewModel {
        return SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func makeRequiredFieldAlertViewModelFor(field: String) -> AlertViewModel{
        return AlertViewModel(title: "Required field", message: "\(field) is required")
    }
    
    func makeInvalidFieldAlertViewModelFor(field: String) -> AlertViewModel{
        return AlertViewModel(title: "Invalid field", message: "\(field) is invalid")
    }
    
    func makeErrorAlertViewModelFor(message: String) -> AlertViewModel{
        return AlertViewModel(title: "Error", message: message)
    }
    
    class AlertViewSpy: AlertView {
        var emit: ((AlertViewModel) -> Void)?
        
        func observe(completion: @escaping (AlertViewModel) -> Void) {
            self.emit = completion
        }
        
        func showMessage(_ alertViewModel: AlertViewModel) {
            self.emit?(alertViewModel)
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        var isValid = true
        var email: String?
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
        
        func simulateInvalidEmail() {
            self.isValid = false
        }
    }
    
    class AddAccountSpy: AddAccount {
        var addAccountModel: AddAccountModel?
        var completion: ((Result<AccountModel, DomainError>) -> Void)?
        
        func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
            self.completion = completion
        }
        
        func completeWithError(_ error: DomainError) -> Void {
            completion?(.failure(.unexpected))
        }
        
    }
}


