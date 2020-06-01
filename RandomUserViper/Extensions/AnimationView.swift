//
//  AnimationView.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 06. 01..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit
import Lottie

extension AnimationView {
    
    /// Configurate a basic `AnimationView` from Lottie.
    /// It looks like a loading animation.
    func configure(on view: UIView) {
        
        loopMode = .loop
        frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        center = view.center
        contentMode = .scaleAspectFill
        play()
        
        view.addSubview(self)
    }
}
