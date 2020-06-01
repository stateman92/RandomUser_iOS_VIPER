//
//  PersistenceServiceContainer.swift
//  RandomUser
//
//  Created by Kálai Kristóf on 2020. 05. 31..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import RealmSwift

// MARK: - Manages the app's persistence.
class PersistenceServiceContainer {
    
    /// Supports the 1 major external library.
    enum PSType {
        case realm
    }
    
    private let service: PersistenceServiceProtocol
    
    init(_ psType: PSType = .realm) {
        switch psType {
        case .realm:
            service = PersistenceServiceRealm()
        }
    }
}

// MARK: - Implement the delegate pattern.
/// Delegate all of the `PersistenceServiceContainerProtocol` methods to the `service` property.
extension PersistenceServiceContainer: PersistenceServiceContainerProtocol {
    
    /// Store a `Persistable` struct into a database.
    func add<T>(_ value: T) where T: Persistable {
        do {
            try service.add(value)
        } catch {
            
        }
    }
    
    /// Store some `Persistable` structs into a database.
    func add<T>(_ sequence: T) where T: Sequence, T.Element: Persistable {
        do {
            try service.add(sequence)
        } catch {
            
        }
    }
    
    /// Delete the `Object` Element from the database.
    func delete<Element>(_ objects: Results<Element>) where Element: Object {
        do {
            try service.delete(objects)
        } catch {
            
        }
    }
    
    /// Retrieve the `Object` Element from the database.
    func objects<Element: Object>(_ type: Element.Type) -> Results<Element> {
        return try! service.objects(type)
    }
}
