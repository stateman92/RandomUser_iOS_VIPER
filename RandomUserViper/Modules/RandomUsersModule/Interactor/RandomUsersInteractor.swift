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
    private var apiService: ApiServiceProtocol
    private var persistenceService: PersistenceServiceProtocol
    
    /// If fetch is in progress, no more network request will be executed.
    var isFetching = false
    
    /// Dependency Injection via Setter Injection.
    func injectPresenter(_ presenterProtocolToInteractor: PresenterProtocolToInteractor) {
        self.presenterProtocolToInteractor = presenterProtocolToInteractor
    }
    
    /// Dependency Injection via Constructor Injection.
    init(_ persistenceServiceType: PersistenceServiceContainer.PSType = .realm) {
        apiService = AppDelegate.container.resolve(ApiServiceProtocol.self)!
        self.persistenceService = PersistenceServiceContainer.init(persistenceServiceType).service
    }
    
    func getUsers(page: Int, results: Int, seed: String) {
        guard isFetching == false else { return }
        isFetching = true
        
        apiService.getUsers(page: page, results: results, seed: seed) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.persistenceService.add(users)
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
        let users = persistenceService.objects(UserObject.self)
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
        persistenceService.deleteAndAdd(UserObject.self, [User]())
    }
}
