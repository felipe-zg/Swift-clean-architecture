import XCTest
import Main

class SignUpIntegrationTests: XCTestCase {
    func testExample() throws {
        let sut = SignUpComposer.composeControllerWith(addAccount: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }
}
