//
//  ImageServiceKingfisher.swift
//  RandomUser
//
//  Created by Kálai Kristóf on 2020. 05. 31..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit
import Kingfisher

/// The `ImageServiceProtocol` implemented by Kingfisher.
class ImageServiceKingfisher: ImageServiceProtocol {
    
    /// Load an url into the image.
    /// - Parameters:
    ///   - url: the url in `URL` format of the image.
    ///   - into: the `UIImageView` that will hold the image.
    ///   - completionHandler: will be called after the image loaded.
    func load(url: URL, into imageView: UIImageView, completionHandler: @escaping () -> ()) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url) { result in
            completionHandler()
        }
    }
}
