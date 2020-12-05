import XCTest
import Presentation
import Validation

class RequiredFieldValidationTests: XCTestCase {

    func test_shoulf_return_error_if_validation_fails() throws {
        let sut = makeSut(fieldName: "email", fieldLabel: "e-mail")
        let errorMessage = sut.validate(data: ["email": ""])
        XCTAssertEqual(errorMessage, "e-mail is required")
    }
    
    func test_shoulf_return_error_message_with_correct_fieldLabel() throws {
        let sut = makeSut(fieldName: "name", fieldLabel: "name")
        let errorMessage = sut.validate(data: ["name": ""])
        XCTAssertEqual(errorMessage, "name is required")
    }
    
    func test_shoulf_return_nil_if_validation_succeeds() throws {
        let sut = makeSut(fieldName: "email", fieldLabel: "e-mail")
        let errorMessage = sut.validate(data: ["email": "valid@email.com"])
        XCTAssertNil(errorMessage)
    }
    
    func test_shoulf_return_error_if_no_data_is_provided() throws {
        let sut = makeSut(fieldName: "name", fieldLabel: "name")
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "name is required")
    }
    
}

extension RequiredFieldValidationTests {
    func makeSut(fieldName: String, fieldLabel: String, file: StaticString = #filePath, line: UInt = #line) -> Validation {
        let sut = RequiredFieldValidation(fieldName: fieldName, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
