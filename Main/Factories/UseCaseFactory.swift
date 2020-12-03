import Foundation
import Data
import Infra
import Domain

final class UseCaseFactory {
    private static let httpClient = AlamofireAdapter()
    private static let apiBaseUrl = Environment.variable(.apiBaseUrl)
    
    private static func makeUrl(endPath: String) -> URL {
        return URL(string: "\(apiBaseUrl)/\(endPath)")!
    }
    
    static func makeRemoteAddAccount() -> AddAccount {
        let remoteAddAccount = RemoteAddAccount(url: makeUrl(endPath: "signup"), httpPostClient: httpClient)
        return MainQueueDispatchDecorator(remoteAddAccount)
    }
}
