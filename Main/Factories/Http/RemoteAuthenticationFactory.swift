import Foundation
import Data
import Domain


func makeRemoteAuthentication(httpPostClient: HttpPostClient) -> Authentication {
    let remoteAuthentication = RemoteAuthentication(url: makeApiUrl(endPath: "login"), httpPostClient: httpPostClient)
    return MainQueueDispatchDecorator(remoteAuthentication)
}
