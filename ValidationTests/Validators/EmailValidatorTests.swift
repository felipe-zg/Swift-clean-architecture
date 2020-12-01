import XCTest
import Validation

class EmailValidatorTests: XCTestCase {

    func test_EmailValidatorAdapter_should_return_false_if_email_is_invalid() throws {
        let sut = makeSut()
        XCTAssertFalse(sut.isValid(email: "something"))
        XCTAssertFalse(sut.isValid(email: "something@anything"))
        XCTAssertFalse(sut.isValid(email: "@something.com"))
        XCTAssertFalse(sut.isValid(email: "something@anything."))
        XCTAssertFalse(sut.isValid(email: "something@anything.c"))
    }
    
    func test_EmailValidatorAdapter_should_return_true_if_email_is_valid() throws {
        let sut = makeSut()
        XCTAssertTrue(sut.isValid(email: "something@yahoo.com.br"))
        XCTAssertTrue(sut.isValid(email: "something@hotmail.com"))
        XCTAssertTrue(sut.isValid(email: "something@outlook.ca"))
        XCTAssertTrue(sut.isValid(email: "something@spark.net"))
    }
}

extension EmailValidatorTests {
    func makeSut() -> EmailValidatorAdapter {
        return EmailValidatorAdapter()
    }
}
