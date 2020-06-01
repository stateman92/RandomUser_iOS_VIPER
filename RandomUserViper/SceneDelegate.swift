//
//  SceneDelegate.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        RandomUsersRouter.navigationController = navigationController
        
        let randomUsers = RandomUsersRouter.createModule()
        navigationController.viewControllers = [randomUsers]
        navigationController.navigationBar.barTintColor = .black
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController.navigationBar.titleTextAttributes = textAttributes
        
        window?.rootViewController = navigationController
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
