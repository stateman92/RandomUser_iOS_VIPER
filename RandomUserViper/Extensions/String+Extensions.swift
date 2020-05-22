//
//  String+Extensions.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import Foundation

extension String {
    
    /// Get a random unique `String`.
    static func getRandomString() -> String {
        return UUID().uuidString
    }
}
