import Foundation
import Data
import Infra

final class UseCaseFactory {
    private static let httpClient = AlamofireAdapter()
    private static let apiBaseUrl = Environment.variable(.apiBaseUrl)
    
    private static func makeUrl(endPath: String) -> URL {
        return URL(string: "\(apiBaseUrl)/\(endPath)")!
    }
    
    static func makeRemoteAddAccount() -> RemoteAddAccount {
        return RemoteAddAccount(url: makeUrl(endPath: "signup"), httpPostClient: httpClient)
    }
}
