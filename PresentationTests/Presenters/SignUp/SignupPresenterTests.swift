import XCTest
import Presentation
import Domain
import Data

class SignUpPresenterTests: XCTestCase {
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
        alertViewSpy.observe { (alertViewModel) in
            XCTAssertEqual(alertViewModel, makeErrorAlertViewModelFor(message: "An unexpected error occured, please try again later"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_success_message_if_addAccount_succeeds() throws {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting test")
        alertViewSpy.observe { (alertViewModel) in
            XCTAssertEqual(alertViewModel, makeSuccessAlertViewModelFor(message: "Account has been created successfully"))
            exp.fulfill()
        }
        sut.signUp(viewModel: makeSignUpModel())
        addAccountSpy.completeWithSuccess(makeAccountModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_show_loadingView_before_and_hide_after_calling_addAccount() throws {
        let loadingViewSpy = LoadingViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(loadingView: loadingViewSpy, addAccount: addAccountSpy)
        let expectetionForBeforeCallingAddAccount = expectation(description: "wainting addAccount to be called")
        loadingViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            expectetionForBeforeCallingAddAccount.fulfill()
        }
        sut.signUp(viewModel: makeSignUpModel())
        wait(for: [expectetionForBeforeCallingAddAccount], timeout: 1)
        let expectetionForAfterCallingAddAccount = expectation(description: "wainting addAccount to be finish")
        loadingViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            expectetionForAfterCallingAddAccount.fulfill()
        }
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [expectetionForAfterCallingAddAccount], timeout: 1)
       
    }
    
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
        sut.signUp(viewModel: makeSignUpModel())
        wait(for: [exp], timeout: 1)
    }
}

extension SignUpPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), loadingView: LoadingViewSpy = LoadingViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy(), addAccount: AddAccountSpy = AddAccountSpy(), validation: ValidationSpy = ValidationSpy(), file: StaticString = #filePath, line: UInt = #line) -> SignUpPresenter{
        let sut = SignUpPresenter(alertView: alertView, loadingView: loadingView, emailValidator: emailValidator, addAccount: addAccount, validation: validation)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
}

