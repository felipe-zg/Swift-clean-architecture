import XCTest
import Data
import Infra
import Domain

class AddAccountIntegrationTests: XCTestCase {

    func test_add_account() throws {
        let uuid = UUID().hashValue
        let alamofireAdapter = AlamofireAdapter()
        let apiUrl = URL(string: "https://fordevs.herokuapp.com/api/signup")!
        let sut = RemoteAddAccount(url: apiUrl, httpPostClient: alamofireAdapter)
        let addAccountModel = AddAccountModel(name: "felipe zeba", email: "\(uuid)@gmail.com", password: "my_password", passwordConfirmation: "my_password")
        let exp = expectation(description: "waiting integration test")
        sut.add(addAccountModel: addAccountModel) { (result) in
            switch result {
            case .failure: XCTFail("expected success but got \(result) instead")
            case .success(let account):
                XCTAssertNotNil(account.accessToken)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 15)
    }
}
