import Foundation
import Data
import Domain


func makeRemoteAddAccount(httpPostClient: HttpPostClient) -> AddAccount {
    let remoteAddAccount = RemoteAddAccount(url: makeApiUrl(endPath: "signup"), httpPostClient: httpPostClient)
    return MainQueueDispatchDecorator(remoteAddAccount)
}
