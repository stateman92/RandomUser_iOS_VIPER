//
//  RandomUserDetailsViewController.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - The View base part.
class RandomUserDetailsViewController: UIViewController {
    
    var user: User!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userAccessibilitiesLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
}

// MARK: - UIViewController lifecycle part.
extension RandomUserDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "\(user.fullName) (\(user.gender))"
        fillLayoutWithData()
        
        userImageView.hero.id = HeroIDs.imageEnlarging.rawValue
        userAccessibilitiesLabel.hero.id = HeroIDs.textEnlarging.rawValue
    }
}

// MARK: - Additional UI-related functions, methods.
extension RandomUserDetailsViewController {
    
    private func fillLayoutWithData() {
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: user.picture.large))
        userAccessibilitiesLabel.text = user.accessibilities
        userLocationLabel.text = user.expandedLocation
    }
}
