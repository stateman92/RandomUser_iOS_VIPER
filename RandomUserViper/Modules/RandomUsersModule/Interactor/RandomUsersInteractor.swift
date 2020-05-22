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
    private var presenterProtocolToInteractor: PresenterProtocolToInteractor?
    
    /// If fetch is in progress, no more network request will be executed.
    var isFetching = false
    
    /// Dependency Injection via Setter Injection.
    func injectPresenter(_ presenterProtocolToInteractor: PresenterProtocolToInteractor) {
        self.presenterProtocolToInteractor = presenterProtocolToInteractor
    }
    
    func getUsers(page: Int, results: Int, seed: String) {
        guard let url = createUrl(page, results, seed) else {
            self.presenterProtocolToInteractor?.didUserFetchFail(errorMessage: errorTypes.cannotBeReached.rawValue)
            return
        }
        guard isFetching == false else { return }
        isFetching = true
        AF.request(url).responseJSON { response in
            do {
                if response.error != nil || response.response?.statusCode == nil {
                    throw RuntimeError(response.error?.localizedDescription ?? errorTypes.wrongRequest.rawValue)
                } else if response.response!.statusCode < 400 {
                    let userResult = try JSONDecoder().decode(UserResult.self, from: response.data!)
                    if page != 1 {
                        self.presenterProtocolToInteractor?.didUserPageSuccess(users: userResult.results)
                        self.isFetching = false
                    } else {
                        self.presenterProtocolToInteractor?.didUserFetchSuccess(users: userResult.results)
                    }
                } else {
                    throw RuntimeError(errorTypes.unexpectedError.rawValue)
                }
            } catch let error {
                self.presenterProtocolToInteractor?.didUserFetchFail(errorMessage: error.localizedDescription)
                self.isFetching = false
            }
        }
    }
    
    /// Creates an `URL` with the given query parameters.
    /// - Note:
    /// The `URL` stores that too, that which data will be requested.
    /// The result of this method request from the API the `name`, `picture`, `gender`, `location`, `email`, `phone` and `cell`.
    private func createUrl(_ page: Int, _ results: Int, _ seed: String) -> URL? {
        let queryItems = [URLQueryItem(name: "inc", value: "name,picture,gender,location,email,phone,cell"),
                          URLQueryItem(name: "page", value: String(page)),
                          URLQueryItem(name: "results", value: String(results)),
                          URLQueryItem(name: "seed", value: String(seed))]
        guard var urlComps = URLComponents(string: getBaseApiUrl()) else { return nil }
        urlComps.queryItems = queryItems
        guard let url = urlComps.url else { return nil }
        return url
    }
}
