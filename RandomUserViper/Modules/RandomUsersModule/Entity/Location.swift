//
//  Location.swift
//  RandomUser
//
//  Created by Kálai Kristóf on 2020. 05. 12..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import Foundation
import RealmSwift

struct Location: Codable {
    let city: String
    let country: String
    let state: String
    let street: Street
    
    static func `nil`() -> Location {
        return Location(city: "", country: "", state: "", street: Street.nil())
    }
}

final class LocationObject: Object {
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var city = ""
    @objc dynamic var country = ""
    @objc dynamic var state = ""
    @objc dynamic var street: StreetObject? = StreetObject()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

extension Location: Persistable {
    
    public init(managedObject: LocationObject) {
        city = managedObject.city
        country = managedObject.country
        state = managedObject.state
        
        if let street = managedObject.street {
            self.street = Street(managedObject: street)
        } else {
            self.street = Street.nil()
        }
    }
    
    public func managedObject() -> LocationObject {
        let location = LocationObject()
        location.city = city
        location.country = country
        location.state = state
        location.street = street.managedObject()
        return location
    }
}
