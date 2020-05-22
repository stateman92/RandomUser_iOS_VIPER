//
//  UIView+Extensions.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Hides the `UIView` with the change of its `alpha` value.
    /// - Parameters:
    ///   - seconds: the duration of the animation (default `0.0`).
    ///   - completion: will be called after the animation ended.
    func hide(_ seconds: Double = 0.0, completion: @escaping (Bool) -> () = { success in }) {
        UIView.animate(withDuration: seconds, animations: {
            self.alpha = 0.0
        }, completion: { success in
            completion(success)
        })
    }
    
    /// Shows the `UIView` with the change of its `alpha` value.
    /// - Parameters:
    ///   - seconds: the duration of the animation (default `0.0`).
    ///   - completion: will be called after the animation ended.
    func show(_ seconds: Double = 0.0, completion: @escaping (Bool) -> () = { success in }) {
        UIView.animate(withDuration: seconds, animations: {
            self.alpha = 1.0
        }, completion: { success in
            completion(success)
        })
    }
}
