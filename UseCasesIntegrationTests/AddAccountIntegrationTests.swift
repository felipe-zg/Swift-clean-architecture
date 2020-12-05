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
        
        //e-mail is not registered yet so it will succeed
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
        
        //E-mail was registered on previous test so it will fall in .emailInUse error condition
        let exp2 = expectation(description: "waiting integration test")
        sut.add(addAccountModel: addAccountModel) { (result) in
            switch result {
            case .failure(let error) where error == .emailInUse:
                XCTAssertNotNil(error)
            default:
                XCTFail("expected success but got \(result) instead")
            }
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 15)
    }
}
