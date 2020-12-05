import Foundation
import XCTest
import Presentation
import Validation

class CompareFieldsValidationTests: XCTestCase {

    func test_shoulf_return_error_if_fields_are_not_equal() throws {
        let sut = makeSut(fieldName: "password", fieldToCompareName: "passwordConfirmation", fieldLabel: "password")
        let errorMessage = sut.validate(data: ["password": "any_passowrd", "passwordConfirmation": "wrong_password"])
        XCTAssertEqual(errorMessage, "password does not match")
    }
    
    func test_shoulf_return_error_message_with_correct_fieldLabel() throws {
        let sut = makeSut(fieldName: "password", fieldToCompareName: "passwordConfirmation", fieldLabel: "password")
        let errorMessage = sut.validate(data: ["password": "any_passowrd", "passwordConfirmation": "wrong_password"])
        XCTAssertEqual(errorMessage, "password does not match")
    }
    
    func test_shoulf_return_nil_if_fields_are_equal() throws {
        let sut = makeSut(fieldName: "password", fieldToCompareName: "passwordConfirmation", fieldLabel: "password")
        let errorMessage = sut.validate(data: ["password": "any_password", "passwordConfirmation": "any_password"])
        XCTAssertNil(errorMessage)
    }
    
    func test_shoulf_return_error_if_no_data_is_provided() throws {
        let sut = makeSut(fieldName: "password", fieldToCompareName: "passwordConfirmation", fieldLabel: "password")
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual(errorMessage, "password does not match")
    }
    
}

extension CompareFieldsValidationTests {
    func makeSut(fieldName: String, fieldToCompareName: String, fieldLabel: String, file: StaticString = #filePath, line: UInt = #line) -> Validation {
        let sut = CompareFieldsValidation(fieldName: fieldName, fieldToCompareName: fieldToCompareName, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
