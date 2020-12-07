import XCTest
import UIKit
@testable import UI
import Presentation

class LoginViewControllerTests: XCTestCase {
    func test_loading_is_hidden_on_start() throws {
        XCTAssertEqual(makeSut().loadingIndicator?.isAnimating, false)
    }
    
    func test_it_implements_LoadingView() throws {
        XCTAssertNotNil(makeSut() as LoadingView)
    }
    
    func test_it_implements_AlertView() throws {
        XCTAssertNotNil(makeSut() as AlertView)
    }
    
    func test_loginButton_calls_login_on_tap() throws {
        var loginVireModel: LoginViewModel?
        let sut = makeSut( loginSpy: { loginVireModel = $0 })
        sut.loginButton?.simulateTap()
        let email = sut.emailTextField?.text
        let password = sut.passwordTextField?.text
        XCTAssertEqual(loginVireModel, LoginViewModel(email: email, password: password))
    }
}

extension LoginViewControllerTests {
    func makeSut(loginSpy: ((LoginViewModel) -> Void)? = nil) -> LoginViewController {
        let sut = LoginViewController.instantiate()
        sut.login = loginSpy
        sut.loadViewIfNeeded()
        return sut
    }
}
