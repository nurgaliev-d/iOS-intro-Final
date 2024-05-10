//
//  SceneDelegate.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let rootVC: UIViewController

        if AuthStorage.shared.token != nil {
            let tabBarController = TabBarController()
            rootVC = tabBarController
        } else {
            let signInVC = SignInViewController()
            let navigationController = UINavigationController(rootViewController: signInVC)
            rootVC = navigationController
        }
        
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window
    }
}

