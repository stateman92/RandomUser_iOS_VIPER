//
//  RealmHelper.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 30..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import RealmSwift

// MARK: - A custom Transaction class.
/// It allows some convenience databse methods.
public final class WriteTransaction {
    private let realm: Realm
    
    internal init(realm: Realm) {
        self.realm = realm
    }
    
    public func add<T: Persistable>(_ value: T) {
        realm.add(value.managedObject(), update: .all)
    }
    
    public func add<T : Sequence>(_ sequence: T) where T.Element: Persistable {
        for element in sequence {
            realm.add(element.managedObject(), update: .all)
        }
    }
    
    public func delete<Element: Object>(_ objects: Results<Element>)  {
        realm.delete(objects)
    }
}

// MARK: - A custom Container class above the Realm database.
public final class Container {
    let realm: Realm
    
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    
    internal init(realm: Realm) {
        self.realm = realm
    }
    
    public func write(_ block: (WriteTransaction) throws -> Void) throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
    }
}
