//
//  Persistable.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 30..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import RealmSwift

// MARK: - The structs that the app wants to save in the Realm Database should implement this.
public protocol Persistable {
    associatedtype ManagedObject: Object
    
    /// Create the `struct` based on the `Object` from the database.
    init(managedObject: ManagedObject)
    
    /// Create the `Object` that will be stored in the database based on the `stuct`.
    func managedObject() -> ManagedObject
}
