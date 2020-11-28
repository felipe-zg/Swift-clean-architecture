import XCTest
import Data
import Infra
import Domain

class AddAccountIntegrationTests: XCTestCase {

    func test_add_account() throws {
        let alamofireAdapter = AlamofireAdapter()
        let apiUrl = URL(string: "https://clean-node-api.herokuapp.com/api/signup")!
        let sut = RemoteAddAccount(url: apiUrl, httpPostClient: alamofireAdapter)
        let addAccountModel = AddAccountModel(name: "felipe zeba", email: "felipe@gmail.com", password: "my_password", passwordConfirmation: "my_password")
        let exp = expectation(description: "waiting integration test")
        sut.add(addAccountModel: addAccountModel) { (result) in
            switch result {
            case .failure: XCTFail("expected success but got \(result) instead")
            case .success(let account):
                XCTAssertNotNil(account.id)
                XCTAssertEqual(account.name, addAccountModel.name)
                XCTAssertEqual(account.email, addAccountModel.email)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}
