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
}

extension LoginViewControllerTests {
    func makeSut(loginSpy: ((LoginViewModel) -> Void)? = nil) -> LoginViewController {
        let sut = LoginViewController.instantiate()
        sut.login = loginSpy
        sut.loadViewIfNeeded()
        return sut
    }
}
