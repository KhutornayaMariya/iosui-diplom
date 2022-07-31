//
//  SceneDelegate.swift
//  MyHabits
//
//  Created by m.khutornaya on 19.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    enum TabBarItem {
        case habitList
        case info
    }

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let tabBarVc = UITabBarController()
        tabBarVc.viewControllers = [createTabBarItem(for: .habitList), createTabBarItem(for: .info)]
        tabBarVc.tabBar.backgroundColor = .white
        tabBarVc.tabBar.tintColor = .purple

        window?.rootViewController = tabBarVc
        window?.makeKeyAndVisible()
    }

    private func createTabBarItem(for item: TabBarItem) -> UINavigationController {
        let navigationController: UINavigationController
        switch item {
        case .habitList:
            navigationController = UINavigationController(rootViewController: HabitsViewController())
            navigationController.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(named: "habits_tab_icon"), selectedImage: nil)
        case .info:
            navigationController = UINavigationController(rootViewController: InfoViewController())
            navigationController.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), selectedImage: nil)
        }

        return navigationController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

