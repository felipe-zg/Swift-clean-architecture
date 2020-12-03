import XCTest
import Main
import UI

class SignUpComposerTests: XCTestCase {
    func test_background_task_should_complete_on_main_thread() throws {
        let (sut, addAccountSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.signUp?(makeSignUpModel())
        let exp = expectation(description: "eaiting")
        DispatchQueue.global().async {
            addAccountSpy.completeWithError(.unexpected)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

extension SignUpComposerTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: SignUpViewController, addAccountSpy: AddAccountSpy) {
        let addAccountSpy = AddAccountSpy()
        let sut = SignUpComposer.composeControllerWith(addAccount: MainQueueDispatchDecorator(addAccountSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: addAccountSpy, file: file, line: line)
        return (sut, addAccountSpy)
    }
}
