import XCTest
import Presentation
import Validation

class ValidationCompositeTests: XCTestCase {
    func test_validate_should_return_error_if_validation_fails() throws {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        validationSpy.simulateError("any error message")
        let errorMessage = sut.validate(data: ["name": "any name"])
        XCTAssertEqual(errorMessage, "any error message")
    }
    
    func test_validate_should_return_the_first_error_found() throws {
        let validationSpy = ValidationSpy()
        let validationSpy2 = ValidationSpy()
        let sut = makeSut(validations: [ValidationSpy(), validationSpy, validationSpy2])
        validationSpy.simulateError("a error message")
        validationSpy2.simulateError("another error message")
        let errorMessage = sut.validate(data: ["name": "any name"])
        XCTAssertEqual(errorMessage, "a error message")
    }
    
    func test_validate_should_return_nil_if_validation_succeeds() throws {
        let sut = makeSut(validations: [ValidationSpy(), ValidationSpy(), ValidationSpy()])
        let errorMessage = sut.validate(data: ["name": "any name"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_call_validation_with_correct_data() throws {
        let validationSpy = ValidationSpy()
        let sut = makeSut(validations: [validationSpy])
        let data = ["name": "any name"]
        _ = sut.validate(data: data)
        XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: data))
    }
}

extension ValidationCompositeTests {
    func makeSut(validations: Array<Validation>, file: StaticString = #filePath, line: UInt = #line) -> Validation{
        let sut = ValidationComposite(validations:validations)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
