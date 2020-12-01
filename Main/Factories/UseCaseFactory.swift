import Foundation
import Data
import Infra

final class UseCaseFactory {
    static func makeRemoteAddAccount() -> RemoteAddAccount {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://clean-node-api.herokuapp.com/api/signup")!
        return RemoteAddAccount(url: url, httpPostClient: alamofireAdapter)
    }
}
