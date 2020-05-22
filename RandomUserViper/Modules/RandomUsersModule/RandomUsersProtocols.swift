//
//  Protocols.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit

// All of the RandomUsersModule's protocols.

// MARK: - Presenter needs to implement this (View use it).
protocol PresenterProtocolToView {
    
    /// VIPER architecture.
    func injectView(_ viewProtocolToPresenter: ViewProtocolToPresenter)
    func injectInteractor(_ interactorProtocolToPresenter: InteractorProtocolToPresenter)
    func injectRouter(_ routerProtocolToPresenter: RouterProtocolToPresenter)
    
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
    
    /// Does not block fetch more. It is necessary because of the animations.
    func enableFetching()
    
    /// Show the details `UIViewController`.
    func showRandomUserDetailsController(selected: Int)
}

// MARK: - View needs to implement this (Presenter use it).
protocol ViewProtocolToPresenter {
    
    /// VIPER architecture.
    func injectPresenter(_ presenterProtocolToView: PresenterProtocolToView)
    
    /// Will be called after it downloads data while previously it contains (locally) no data.
    func didRandomUsersAvailable()
    
    /// Will be called if the refresh (download new users with new seed value) starts.
    func willRandomUsersRefresh()
    
    /// Will be called if the paging is done (and can be more data requested).
    func didEndRandomUsersPaging()
    
    /// Will be called if any error occured while the requests.
    func didErrorOccuredWhileDownload(errorMessage: String)
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
}

extension InteractorProtocolToPresenter {
    
    /// The API URL (in `String`).
    /// - Note:
    /// The number in the `String` indicate the used version of the API.
    /// With `1.3` it works fine, but maybe a newer version would break the implementation.
    func getBaseApiUrl() -> String {
        return "https://randomuser.me/api/1.3/"
    }
}

// MARK: - Presenter needs to implement this (Interactor use it).
protocol PresenterProtocolToInteractor {
    
    /// Will be called if the fetch (after a new seed value) was successful.
    func didUserFetchSuccess(users: [User])
    
    /// Will be called if the fetch (about paging) was successful.
    func didUserPageSuccess(users: [User])
    
    /// Will be called if any error occured while the requests.
    func didUserFetchFail(errorMessage: String)
}
