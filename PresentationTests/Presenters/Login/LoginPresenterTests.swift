import XCTest
import Presentation
import Domain


class LoginPresenterTests: XCTestCase {
    func test_login_should_show_error_message_if_validation_fails() throws {
        let alertViewSpy = AlertViewSpy()
        let validationSpy = ValidationSpy()
        let sut = makeSut(alertView: alertViewSpy, validation: validationSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe {(viewModel) in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Validation failed", message: "any error acorrued"))
            exp.fulfill()
        }
        validationSpy.simulateError()
        sut.login(viewModel: makeLoginViewModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_login_should_call_authentication_with_correct_values() throws {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(authentication: authenticationSpy)
        sut.login(viewModel: makeLoginViewModel())
        XCTAssertEqual(authenticationSpy.authenticationModel, makeAuthenticationModel())
    }
    
    func test_login_should_show_error_message_if_authentication_fails() throws {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = makeSut(alertView: alertViewSpy, authentication: authenticationSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe { (alertViewModel) in
            XCTAssertEqual(alertViewModel, makeErrorAlertViewModelFor(message: "An unexpected error occured, please try again later"))
            exp.fulfill()
        }
        sut.login(viewModel: makeLoginViewModel())
        authenticationSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
}

extension LoginPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), validation: ValidationSpy = ValidationSpy(), authentication: AuthenticationSpy = AuthenticationSpy(), file: StaticString = #filePath, line: UInt = #line) -> LoginPresenter {
        let sut = LoginPresenter(alertiView: alertView, validation: validation, authentication: authentication)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
}

