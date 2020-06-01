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
    
    /// VIPER architecture elements.
    private var randomUserViewProtocol: RandomUserViewProtocol?
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
    
    /// `RandomUserPresenterProtocol` variables part.
    
    /// The so far fetched user data.
    var users = [User]()
}

// MARK: The PresenterProtocolToInteractor part (Interactor calls this).
extension RandomUsersPresenter: PresenterProtocolToInteractor {
    
    /// Will be called if (after a new seed value) the fetch was successful.
    func didUserFetchSuccess(users: [User]) {
        self.users.append(contentsOf: users)
        if users.count == numberOfUsersPerPage {
            randomUserViewProtocol?.didRandomUsersAvailable {
                self.interactorProtocolToPresenter?.isFetching = false
            }
        } else {
            randomUserViewProtocol?.didEndRandomUsersPaging()
        }
    }
    
    /// Will be called if the fetch (about paging) was successful.
    func didUserFetchFail(errorMessage: String) {
        randomUserViewProtocol?.didErrorOccuredWhileDownload(errorMessage: errorMessage)
    }
    
    /// Will be called after the cache loaded.
    func didCacheLoadFinished(_ result: Result<[User], ErrorTypes>) {
        switch result {
        case .success(let users):
            self.users.append(contentsOf: users)
            randomUserViewProtocol?.didRandomUsersAvailable {
                self.interactorProtocolToPresenter?.isFetching = false
            }
        case .failure(_):
            interactorProtocolToPresenter?.isFetching = false
            getRandomUsers()
        }
    }
}

// MARK: The PresenterProtocolToView part (View calls this).
extension RandomUsersPresenter: RandomUserPresenterProtocol {
    
    func showRandomUserDetailsController(selected: Int) {
        routerProtocolToPresenter?.pushToRandomUserDetailsScreen(selectedUser: users[selected])
    }
    
    /// Returns the so far fetched data + number of users in a page.
    /// - Note:
    /// If the number of the displayed user is greater or equal with the `users.count` but less than the `currentMaxUsers`,
    ///     the View can display a loading icon.
    var currentMaxUsers: Int {
        return nextPage * numberOfUsersPerPage
    }
    
    /// Self-check, that actually distinct users are fetched.
    /// - Note:
    /// Can be used to display somewhere.
    var numberOfDistinctNamedPeople: Int {
        Set(users.map { user -> String in
            user.fullName
        }).count
    }
    
    /// Dependency Injection via Setter Injection.
    func injectView(_ randomUserViewProtocol: RandomUserViewProtocol) {
        self.randomUserViewProtocol = randomUserViewProtocol
    }
    
    /// Dependency Injection via Setter Injection.
    func injectInteractor(_ interactorProtocolToPresenter: InteractorProtocolToPresenter) {
        self.interactorProtocolToPresenter = interactorProtocolToPresenter
    }
    
    /// Dependency Injection via Setter Injection.
    func injectRouter(_ routerProtocolToPresenter: RouterProtocolToPresenter) {
        self.routerProtocolToPresenter = routerProtocolToPresenter
    }
    
    /// Fetch some random users.
    func getRandomUsers() {
        interactorProtocolToPresenter?.getUsers(page: nextPage, results: numberOfUsersPerPage, seed: seed)
    }
    
    /// Fetch some new random users.
    /// - Note:
    /// Remove all so far downloaded data, recreate the seed value.
    /// Immediately calls the `randomUsersRefreshStarted()` method of the `delegate`.
    /// - Parameters:
    ///   - withDelay: the duration after the fetch starts.
    func refresh(withDelay delay: Double = 0) {
        users.removeAll()
        self.interactorProtocolToPresenter?.deleteCachedData()
        seed = String.getRandomString()
        randomUserViewProtocol?.willRandomUsersRefresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.getRandomUsers()
        }
    }
    
    /// Retrieve the previously cached users.
    func getCachedUsers() {
        interactorProtocolToPresenter?.isFetching = true
        run(1.0) {
            self.interactorProtocolToPresenter?.getCachedData()
        }
    }
}
