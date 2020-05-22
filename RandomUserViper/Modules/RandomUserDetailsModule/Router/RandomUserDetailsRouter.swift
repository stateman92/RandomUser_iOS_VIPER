//
//  RandomUserDetailsRouter.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit

// MARK: - The Router base part.
class RandomUserDetailsRouter {
    
    static var navigationController: UINavigationController?
    
    static func createModule(user: User) -> RandomUserDetailsViewController {
        let view = AppDelegate.mainStoryboard.instantiateViewController(withIdentifier: "RandomUserDetailsViewController") as! RandomUserDetailsViewController
        view.user = user
        return view
    }
}
