//
//  User.swift
//  RandomUser
//
//  Created by Kálai Kristóf on 2020. 05. 12..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: Name
    let picture: Picture
    let gender: String
    let email: String
    let phone: String
    let cell: String
    let location: Location
    
    /// Returns the full name (firstly the first name and then the last).
    var fullName: String {
        return "\(name.title) \(name.first) \(name.last)"
    }
    
    /// Returns the ways the user can be reached in a formatted `String`.
    var accessibilities: String {
        return "Contacts:\n\tEmail: \(email)\n\tCellphone: \(cell)\n\tPhone: \(phone)"
    }
    
    /// Returns the location of the user in a formatted `String`.
    var expandedLocation: String {
        return "Address:\n\t\(location.country), \(location.state), \(location.city)\n\tStreet \(location.street.name) \(location.street.number)"
    }
}
