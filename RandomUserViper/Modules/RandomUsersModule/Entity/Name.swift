//
//  Name.swift
//  RandomUser
//
//  Created by Kálai Kristóf on 2020. 05. 12..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import Foundation
import RealmSwift

struct Name: Codable {
    let first: String
    let last: String
    let title: String
    
    static func `nil`() -> Name {
        return Name(first: "", last: "", title: "")
    }
}

final class NameObject: Object {
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var first = ""
    @objc dynamic var last = ""
    @objc dynamic var title = ""
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

extension Name: Persistable {
    
    public init(managedObject: NameObject) {
        first = managedObject.first
        last = managedObject.last
        title = managedObject.title
    }
    
    public func managedObject() -> NameObject {
        let name = NameObject()
        name.first = first
        name.last = last
        name.title = title
        return name
    }
}
