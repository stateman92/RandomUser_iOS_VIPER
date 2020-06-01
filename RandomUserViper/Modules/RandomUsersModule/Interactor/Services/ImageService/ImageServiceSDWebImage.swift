//
//  ImageServiceSDWebImage.swift
//  RandomUser
//
//  Created by Kálai Kristóf on 2020. 05. 31..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import SDWebImage

/// The `ImageServiceProtocol` implemented by SDWebImage.
class ImageServiceSDWebImage: ImageServiceProtocol {
    
    /// Load an url into the image.
    /// - Parameters:
    ///   - url: the url in `URL` format of the image.
    ///   - into: the `UIImageView` that will hold the image.
    ///   - completionHandler: will be called after the image loaded.
    func load(url: URL, into imageView: UIImageView, completionHandler: @escaping () -> ()) {
        imageView.sd_setImage(with: url) { (uiimage, error, cacheType, url) in
            completionHandler()
        }
    }
}
