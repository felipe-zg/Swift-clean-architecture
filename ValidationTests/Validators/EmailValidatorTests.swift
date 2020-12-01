import XCTest
import Validation

class EmailValidatorTests: XCTestCase {

    func test_() throws {
        let sut = makeSut()
        XCTAssertFalse(sut.isValid(email: "something"))
        XCTAssertFalse(sut.isValid(email: "something@anything"))
        XCTAssertFalse(sut.isValid(email: "@something.com"))
        XCTAssertFalse(sut.isValid(email: "something@anything."))
        XCTAssertFalse(sut.isValid(email: "something@anything.c"))
    }
}

extension EmailValidatorTests {
    func makeSut() -> EmailValidatorAdapter {
        return EmailValidatorAdapter()
    }
}
