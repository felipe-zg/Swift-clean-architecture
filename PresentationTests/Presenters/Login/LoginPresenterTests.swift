import XCTest
import Presentation
import Domain


class LoginPresenterTests: XCTestCase {
    func test_signUp_should_show_error_message_if_validation_fails() throws {
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
}

extension LoginPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), validation: ValidationSpy = ValidationSpy(),file: StaticString = #filePath, line: UInt = #line) -> LoginPresenter {
        let sut = LoginPresenter(alertiView: alertView, validation: validation)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
}

