//
//  Protocols.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit

// MARK: - VIPER architecture's elements.



// MARK: - Presenter needs to implement this (View use it).
protocol RandomUserPresenterProtocol {
    
    /// VIPER architecture.
    func injectView(_ randomUserViewProtocol: RandomUserViewProtocol)
    func injectInteractor(_ interactorProtocolToPresenter: InteractorProtocolToPresenter)
    func injectRouter(_ routerProtocolToPresenter: RouterProtocolToPresenter)
    
    /// Show the details `UIViewController`.
    func showRandomUserDetailsController(selected: Int)
    
    /// The so far fetched user data.
    var users: [User] { get set }
    
    /// Returns the so far fetched data + number of users in a page.
    var currentMaxUsers: Int { get }
    
    /// Self-check, that actually distinct users are fetched.
    var numberOfDistinctNamedPeople: Int { get }
    
    /// Fetch some random users.
    func getRandomUsers()
    
    /// Fetch some new random users.
    func refresh(withDelay: Double)
    
    /// Retrieve the previously cached users.
    func getCachedUsers()
}

// MARK: - View needs to implement this (Presenter use it).
protocol RandomUserViewProtocol: class {
    
    /// VIPER architecture.
    func injectPresenter(_ presenterProtocolToView: RandomUserPresenterProtocol)
    
    /// Will be called after it downloads data while previously it contains (locally) no data.
    /// - Parameters:
    ///   - completion: must be called after the view presented correctly.
    func didRandomUsersAvailable(_ completion: @escaping () -> Void)
    
    /// Will be called if the refresh (download new users with new seed value) starts.
    func willRandomUsersRefresh()
    
    /// Will be called if the paging is done (and can be more data requested).
    func didEndRandomUsersPaging()
    
    /// Will be called if any error occured while the requests.
    /// - Parameters:
    ///   - errorMessage: the description of the error.
    func didErrorOccuredWhileDownload(errorMessage: String)
}

extension RandomUserViewProtocol {
    
    /// Will be called after it downloads data while previously it contains (locally) no data. It's the customization of the `RandomUserViewProtocol`'s `didRandomUsersAvailable(completion:)` method.
    /// - Parameters:
    ///   - completion: optional argument, by default it does nothing.
    func didRandomUsersAvailable(_ completion: @escaping () -> Void = { }) {
        didRandomUsersAvailable {
            completion()
        }
    }
}

// MARK: - Router needs to implement this (Presenter use it).
protocol RouterProtocolToPresenter {
    
    /// VIPER architecture.
    static func createModule() -> RandomUsersViewController
    
    /// Store the `UINavigationController` to be able to push the details.
    static var navigationController: UINavigationController? { get set }
    
    /// Push the details `UIViewController`.
    func pushToRandomUserDetailsScreen(selectedUser user: User)
}

// MARK: - Interactor needs to implement this (Presenter use it).
protocol InteractorProtocolToPresenter {
    
    /// VIPER architecture.
    func injectPresenter(_ presenterProtocolToInteractor: PresenterProtocolToInteractor)
    
    /// Shows whether it is busy with some network calls.
    var  isFetching: Bool { get set }
    
    /// Download random users with the given parameters.
    /// - Parameters:
    ///   - page: the page that you want to download.
    ///   - results: the number of results in a page.
    ///   - seed: the API use this to give some data. For the same seed, it gives back the same results.
    func getUsers(page: Int, results: Int, seed: String)
    
    /// Try to load the previously cached data.
    func getCachedData()
    
    /// Delete the previously cached data.
    func deleteCachedData()
}

// MARK: - Presenter needs to implement this (Interactor use it).
protocol PresenterProtocolToInteractor: class {
    
    /// Will be called if the fetch (after a new seed value) was successful.
    func didUserFetchSuccess(users: [User])
    
    /// Will be called if any error occured while the requests.
    func didUserFetchFail(errorMessage: String)
    
    /// Will be called after the cache loaded.
    func didCacheLoadFinished(_ result: Result<[User], ErrorTypes>)
}
