//
//  RandomUserDetailsViewController.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit
import SkeletonView

// MARK: - The main ViewController base part.
class RandomUserDetailsViewController: UIViewController {
    
    var user: User!
    private let imageServiceContainer: ImageServiceContainerProtocol = ImageServiceContainer()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userAccessibilitiesLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
}

// MARK: - UIViewController lifecycle part.
extension RandomUserDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isSkeletonable = true
        userImageView.isSkeletonable = true
        
        navigationItem.title = "\(user.fullName) (\(user.gender))"
        fillLayoutWithData()
        
        userImageView.hero.id = HeroIDs.imageEnlarging.rawValue
        userAccessibilitiesLabel.hero.id = HeroIDs.textEnlarging.rawValue
    }
}

// MARK: - Additional UI-related functions, methods.
extension RandomUserDetailsViewController {
    
    private func fillLayoutWithData() {
        userAccessibilitiesLabel.text = user.accessibilities
        userLocationLabel.text = user.expandedLocation
        userImageView.backgroundColor = .darkGray
        
        // The placeholder will be a SkeletonView, something like Facebook.
        let gradient = SkeletonGradient(baseColor: .darkGray)
        userImageView.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(1))
        
        imageServiceContainer.load(url: user.picture.large, into: userImageView, withDelay: 2.0) {
            self.userImageView.hideSkeleton()
        }
    }
}
