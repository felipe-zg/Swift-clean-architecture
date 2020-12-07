import XCTest
import Main
import UI
import Validation

class LoginFactoryTests: XCTestCase {
    func test_login_composes_with_correct_validations() throws {
        let validations = makeLoginValidations()
        XCTAssertEqual(validations[0] as! RequiredFieldValidation, RequiredFieldValidation(fieldName: "email", fieldLabel: "e-mail"))
        XCTAssertEqual(validations[1] as! EmailValidation, EmailValidation(fieldName: "email", fieldLabel: "e-mail", emailValidator: EmailValidatorSpy()))
        XCTAssertEqual(validations[2] as! RequiredFieldValidation, RequiredFieldValidation(fieldName: "password", fieldLabel: "password"))
    }
}

extension LoginFactoryTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: LoginViewController, authenticationSpy: AuthenticationSpy) {
        let authenticationSpy = AuthenticationSpy()
        let sut = makeLoginController(authentication: authenticationSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: authenticationSpy, file: file, line: line)
        return (sut, authenticationSpy)
    }
}
