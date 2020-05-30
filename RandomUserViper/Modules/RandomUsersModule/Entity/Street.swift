//
//  Street.swift
//  RandomUser
//
//  Created by Kálai Kristóf on 2020. 05. 12..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import Foundation
import RealmSwift

struct Street: Codable {
    let name: String
    let number: Int
    
    static func `nil`() -> Street {
        return Street(name: "", number: 0)
    }
}

final class StreetObject: Object {
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var number = 0
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

extension Street: Persistable {
    
    public init(managedObject: StreetObject) {
        name = managedObject.name
        number = managedObject.number
    }
    
    public func managedObject() -> StreetObject {
        let street = StreetObject()
        street.name = name
        street.number = number
        return street
    }
}
