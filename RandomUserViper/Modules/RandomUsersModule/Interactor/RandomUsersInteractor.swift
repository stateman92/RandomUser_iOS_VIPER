//
//  RandomUsersInteractor.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - The RandomUsersModule's Interactor base part.
// It can be change to Moya implementation as far as it implements the InteractorProtocolToPresenter.
class RandomUsersInteractor: InteractorProtocolToPresenter {
    
    /// VIPER architecture element (Presenter).
    private weak var presenterProtocolToInteractor: PresenterProtocolToInteractor?
    private var apiServiceContainer: ApiServiceContainerProtocol
    private var persistenceServiceContainer: PersistenceServiceContainerProtocol
    
    /// If fetch is in progress, no more network request will be executed.
    var isFetching = false
    
    /// Dependency Injection via Setter Injection.
    func injectPresenter(_ presenterProtocolToInteractor: PresenterProtocolToInteractor) {
        self.presenterProtocolToInteractor = presenterProtocolToInteractor
    }
    
    /// Dependency Injection via Constructor Injection.
    init(_ apiServiceType: ApiServiceContainer.USType = .alamofire, _ persistenceServiceType: PersistenceServiceContainer.PSType = .realm) {
        self.apiServiceContainer = ApiServiceContainer.init(apiServiceType)
        self.persistenceServiceContainer = PersistenceServiceContainer.init(persistenceServiceType)
    }
    
    func getUsers(page: Int, results: Int, seed: String) {
        guard isFetching == false else { return }
        isFetching = true
        
        apiServiceContainer.getUsers(page: page, results: results, seed: seed) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.persistenceServiceContainer.add(users)
                self.presenterProtocolToInteractor?.didUserFetchSuccess(users: users)
            case .failure(let errorType):
                self.presenterProtocolToInteractor?.didUserFetchFail(errorMessage: errorType.rawValue)
                self.isFetching = false
            }
        }
    }
    
    /// Try to load the previously cached data.
    func getCachedData() {
        isFetching = true
        var returnUsers = [User]()
        let users = persistenceServiceContainer.objects(UserObject.self)
        for user in users {
            returnUsers.append(User(managedObject: user))
        }
        if returnUsers.count == 0 {
            presenterProtocolToInteractor?.didCacheLoadFinished(.failure(.unexpectedError))
        } else {
            presenterProtocolToInteractor?.didCacheLoadFinished(.success(returnUsers))
        }
    }
    
    /// Delete the previously cached data.
    func deleteCachedData() {
        persistenceServiceContainer.deleteAndAdd(UserObject.self, [User]())
    }
}
