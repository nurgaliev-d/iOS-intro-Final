//
//  TabBarController.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    func setupTabs() {
        let eventsVC = UINavigationController(rootViewController: EventsViewController())
        let regiteredVC = UINavigationController(rootViewController: RegisteredViewController())
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        eventsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "homekit") , selectedImage: UIImage(systemName: "homekit.fill"))
        favoriteVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        regiteredVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bookmark"), selectedImage: UIImage(systemName: "bookmark.fill"))
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "custom.person.fill"))
        
        setViewControllers([eventsVC, regiteredVC, favoriteVC, profileVC], animated: false)
    }
}
