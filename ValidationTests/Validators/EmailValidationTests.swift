import Foundation
import XCTest
import Presentation
import Validation

class EmailValidationTests: XCTestCase {

    func test_shoulf_return_error_if_email_is_not_valid() throws {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(fieldName: "email",fieldLabel: "e-mail", emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email": "invalid@email.com"])
        XCTAssertEqual(errorMessage, "e-mail is not valid")
    }
    
    func test_shoulf_return_error_message_with_correct_field_label() throws {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(fieldName: "email",fieldLabel: "e-mail", emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email": "invalid@email.com"])
        XCTAssertEqual(errorMessage, "e-mail is not valid")
    }
    
    func test_shoulf_return_nil_if_email_is_valid() throws {
        let sut = makeSut(fieldName: "email",fieldLabel: "e-mail", emailValidator: EmailValidatorSpy())
        let errorMessage = sut.validate(data: ["email": "valid@email.com"])
        XCTAssertNil(errorMessage)
    }
    
    func test_shoulf_return_error_if_no_data_is_provided() throws {
        let sut = makeSut(fieldName: "email",fieldLabel: "e-mail", emailValidator: EmailValidatorSpy())
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "e-mail is not valid")
    }
    
}

extension EmailValidationTests {
    func makeSut(fieldName: String, fieldLabel: String, emailValidator: EmailValidator,  file: StaticString = #filePath, line: UInt = #line) -> Validation {
        let sut = EmailValidation(fieldName: fieldName, fieldLabel: fieldLabel, emailValidator: emailValidator)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
