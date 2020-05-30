//
//  RandomUsersPresenter.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - The RandomUsersModule's Presenter base part.
class RandomUsersPresenter {
    
    /// VIPER architecture elements (View, Interactor).
    private var viewProtocolToPresenter: ViewProtocolToPresenter?
    private var interactorProtocolToPresenter: InteractorProtocolToPresenter?
    private var routerProtocolToPresenter: RouterProtocolToPresenter?
    
    /// Number of users that will be downloaded at the same time.
    private let numberOfUsersPerPage = 10
    /// The initial seed value. Changed after all refresh / restart.
    private var seed = String.getRandomString()
    
    /// Returns the number of the next page.
    private var nextPage: Int {
        return users.count / numberOfUsersPerPage + 1
    }
    
    /// RandomUserPresenterProtocol variables part.
    
    /// The so far fetched user data.
    var users = [User]()
}

// MARK: The PresenterProtocolToInteractor part (Interactor calls this).
extension RandomUsersPresenter: PresenterProtocolToInteractor {
    
    /// Will be called if (after a new seed value) the fetch was successful.
    func didUserFetchSuccess(users: [User]) {
        newValueArrived(users: users)
        viewProtocolToPresenter?.didRandomUsersAvailable()
    }
    
    /// Will be called if the fetch (about paging) was successful.
    func didUserFetchFail(errorMessage: String) {
        viewProtocolToPresenter?.didErrorOccuredWhileDownload(errorMessage: errorMessage)
    }
    
    /// Will be called if any error occured while the requests.
    func didUserPageSuccess(users: [User]) {
        newValueArrived(users: users)
        viewProtocolToPresenter?.didEndRandomUsersPaging()
    }
    
    private func newValueArrived(users: [User]) {
        self.users.append(contentsOf: users)
        do {
            let container = try Container()
            try container.write { transaction in
                transaction.delete(container.realm.objects(UserObject.self))
                transaction.add(self.users)
            }
        } catch {
            
        }
    }
}

// MARK: The PresenterProtocolToView part (View calls this).
extension RandomUsersPresenter: PresenterProtocolToView {
    
    func showRandomUserDetailsController(selected: Int) {
        routerProtocolToPresenter?.pushToRandomUserDetailsScreen(selectedUser: users[selected])
    }
    
    /// Returns the so far fetched data + number of users in a page.
    /// If the number of the displayed user is greater or equal with the `users.count` but less than the `currentMaxUsers`,
    ///     the View can display a loading icon.
    var currentMaxUsers: Int {
        return nextPage * numberOfUsersPerPage
    }
    
    /// Self-check, that actually distinct users are fetched.
    /// Can be used to display somewhere.
    var numberOfDistinctNamedPeople: Int {
        Set(users.map { user -> String in
            user.fullName
        }).count
    }
    
    /// Dependency Injection via Setter Injection.
    func injectView(_ viewProtocolToPresenter: ViewProtocolToPresenter) {
        self.viewProtocolToPresenter = viewProtocolToPresenter
    }
    
    /// Dependency Injection via Setter Injection.
    func injectInteractor(_ interactorProtocolToPresenter: InteractorProtocolToPresenter) {
        self.interactorProtocolToPresenter = interactorProtocolToPresenter
    }
    
    /// Dependency Injection via Setter Injection.
    func injectRouter(_ routerProtocolToPresenter: RouterProtocolToPresenter) {
        self.routerProtocolToPresenter = routerProtocolToPresenter
    }
    
    func enableFetching() {
        interactorProtocolToPresenter?.isFetching = false
    }
    
    /// Fetch some new random users.
    /// Remove all so far downloaded data, recreate the seed value.
    /// Immediately calls the `randomUsersRefreshStarted()` method of the `viewProtocolToPresenter`.
    /// - Parameters:
    ///   - withDelay: the duration after the fetch starts.
    func refresh(withDelay delay: Double = 0) {
        users.removeAll()
        seed = String.getRandomString()
        viewProtocolToPresenter?.willRandomUsersRefresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.getRandomUsers()
        }
    }
    
    /// Fetch some random users.
    func getRandomUsers() {
        interactorProtocolToPresenter?.getUsers(page: nextPage, results: numberOfUsersPerPage, seed: seed)
    }
    
    /// Load the previously cached users.
    func getCachedUsers() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            defer {
                self.viewProtocolToPresenter?.stopRefreshing()
            }
            do {
                let users = try Container().realm.objects(UserObject.self)
                if users.count > self.numberOfUsersPerPage {
                    for user in users {
                        self.users.append(User(managedObject: user))
                    }
                    self.viewProtocolToPresenter?.didRandomUsersAvailable()
                }
            } catch {
                
            }
        }
    }
}
