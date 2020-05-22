//
//  RandomUserTableViewCell.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - The UITableViewCell part.
class RandomUserTableViewCell: UITableViewCell {
    
    /// The "content", also every visible things that the user wants to see.
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    /// If the content not ready, shows a loading animation.
    var activityIndicatorView: UIActivityIndicatorView?
    
    private var isAnimating: Bool {
        return activityIndicatorView?.isAnimating ?? false
    }
}

// MARK: - Additional UI-related functions, methods.
extension RandomUserTableViewCell {
    
    /// It must be called after a cell is created. It sets the background and the loading icon.
    func initialize() {
        backgroundColor = .clear
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView?.color = .white
        backgroundView = activityIndicatorView
    }
    
    /// Shows the data of the user.
    func configureData(withUser user: User?) {
        guard let user = user else { return }
        userName?.text = user.fullName
        userImage.kf.indicatorType = .activity
        userImage.kf.setImage(with: URL(string: user.picture.large))
    }
    
    /// Shows the data that the user wants to see.
    func showContent() {
        let seconds: Double
        // If animating, than the content will be slowly appear.
        // Otherwise it shows immediately, since it doesn't need to be (dis)appear.
        if isAnimating {
            seconds = 1.0
        } else {
            seconds = 0.0
        }
        
        activityIndicatorView?.stopAnimating()
        userImage.show(seconds)
        userName.show(seconds)
        nameLabel.show(seconds)
    }
    
    /// Hides all the content (e.g. the data not yet fetched), and start animating.
    func hideContent() {
        activityIndicatorView?.startAnimating()
        userImage.hide()
        userName.hide()
        nameLabel.hide()
    }
}
