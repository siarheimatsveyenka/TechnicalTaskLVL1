import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let firstVc = UsersListViewController(
            viewModel: UsersListViewModel(
                updatingUsersDataFacade: UpdatingUsersDataFacade(
                    coreDataService: CoreDataService(),
                    networkService: NetworkService(),
                    internetChecker: InternetCheckingService()
                ),
                coreDataService: CoreDataService()
            )
        )
        
        let navController = UINavigationController(rootViewController: firstVc)
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
