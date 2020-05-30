//
//  User.swift
//  RandomUser
//
//  Created by Kálai Kristóf on 2020. 05. 12..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import Foundation
import RealmSwift

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

final class UserObject: Object {
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var name: NameObject? = NameObject()
    @objc dynamic var picture: PictureObject? = PictureObject()
    @objc dynamic var gender = ""
    @objc dynamic var email = ""
    @objc dynamic var phone = ""
    @objc dynamic var cell = ""
    @objc dynamic var location: LocationObject? = LocationObject()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

extension User: Persistable {
    
    public init(managedObject: UserObject) {
        gender = managedObject.gender
        email = managedObject.email
        phone = managedObject.phone
        cell = managedObject.cell
        
        if let location = managedObject.location {
            self.location = Location(managedObject: location)
        } else {
            self.location = Location.nil()
        }
        
        if let name = managedObject.name {
            self.name = Name(managedObject: name)
        } else {
            self.name = Name.nil()
        }
        
        if let picture = managedObject.picture {
            self.picture = Picture(managedObject: picture)
        } else {
            self.picture = Picture.nil()
        }
    }
    
    public func managedObject() -> UserObject {
        let user = UserObject()
        user.name = name.managedObject()
        user.picture = picture.managedObject()
        user.gender = gender
        user.email = email
        user.phone = phone
        user.cell = cell
        user.location = location.managedObject()
        return user
    }
}
