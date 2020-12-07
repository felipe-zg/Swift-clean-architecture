import UIKit
import UI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let httpPostClient = makeAlamofireAdapter()
        let addAccount = makeRemoteAddAccount(httpPostClient: httpPostClient)
        let signUpViewController = makeSignUpController(addAccount: addAccount)
        let navigationController = NavigationController(rootViewController: signUpViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


