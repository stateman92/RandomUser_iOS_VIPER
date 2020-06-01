//
//  ImageProvider.swift
//  RandomUser
//
//  Created by Kálai Kristóf on 2020. 05. 31..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit

// MARK: - Manages downloading images in the app.
class ImageServiceContainer {
    
    /// Supports the 3 major external libraries.
    enum ISType {
        case nuke
        case kingfisher
        case sdwebimage
    }
    
    private let service: ImageServiceProtocol
    
    init(_ isType: ISType = .nuke) {
        switch isType {
        case .nuke:
            service = ImageServiceNuke()
        case .kingfisher:
            service = ImageServiceKingfisher()
        case .sdwebimage:
            service = ImageServiceSDWebImage()
        }
    }
    
    /// Called after the image loaded.
    /// Stops animating, then calls the completion method.
    private func loaded(_ activityIndicator: UIActivityIndicatorView?, _ completion: () -> () = { }) {
        activityIndicator?.stopAnimating()
        completion()
    }
}

// MARK: - Implement the delegate pattern.
/// Delegate all of the `ImageServiceContainerProtocol` methods to the `service` property.
extension ImageServiceContainer: ImageServiceContainerProtocol {
    
    /// Load an url into the image.
    /// - Parameters:
    ///   - url: the url in `String` format of the image.
    ///   - into: the `UIImageView` that will hold the image.
    ///   - withDelay: seconds, after the image loading will start.
    ///   - isLoadingPresenting: whether it shows a loading animation before it loaded.
    ///   - completionHandler: will be called after the image loaded.
    func load(url urlString: String, into imageView: UIImageView, withDelay delay: Double, isLoadingPresenting loading: Bool, completionHandler: @escaping () -> Void) {
        
        var activityIndicator: UIActivityIndicatorView? = nil
        if loading {
            activityIndicator = imageView.setActivityIndicator()
        }
        
        guard let url = URL(string: urlString) else { return }
        
        run(delay) {
            self.service.load(url: url, into: imageView) {
                self.loaded(activityIndicator, completionHandler)
            }
        }
    }
}
