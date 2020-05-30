//
//  RandomUsersViewController.swift
//  RandomUserViper
//
//  Created by Kálai Kristóf on 2020. 05. 17..
//  Copyright © 2020. Kálai Kristóf. All rights reserved.
//

import UIKit

// MARK: - The RandomUsersModule's ViewController base part.
class RandomUsersViewController: UIViewController {
    
    /// VIPER architecture element.
    var presenterProtocolToView: PresenterProtocolToView?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    /// Shows weather the initial users' data downloaded.
    private var activityIndicatorView = UIActivityIndicatorView()
    
    /// After the user claim that wants to refresh, the cells dissolves with this delay. After that the Presenter can start the refresh.
    private let refreshDelay = 0.33
}

// MARK: - UIViewController lifecycle part.
extension RandomUsersViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButtonOnNextVC()
        setupLeftBarButton()
        
        activityIndicatorView.configure()
        setupTableViewAndRefreshing()
        
        activityIndicatorView.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.visibleCells.forEach { cell in
            if let cell = cell as? RandomUserTableViewCell {
                cell.userImage.hero.id = HeroIDs.defaultValue.rawValue
                cell.userName.hero.id = HeroIDs.defaultValue.rawValue
            }
        }
    }
}

// MARK: - UITableView functions part.
extension RandomUsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// If currently refreshing or downloads the initial users, show `0` cells. Otherwise show the `currentMaxUsers`.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        refreshUserCounter()
        if activityIndicatorView.isAnimating || refreshControl.isRefreshing {
            return 0
        } else {
            return presenterProtocolToView?.currentMaxUsers ?? 0
        }
    }
    
    /// If the cell is ready to be displayed, then display it, otherwise show a loading animation (with hidden content).
    /// - SeeAlso:
    /// `PresenterProtocolToView`'s `currentMaxUsers` variable.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RandomUserTableViewCell = tableView.cell(indexPath: indexPath)
        cell.initialize()
        if indexPath.row < presenterProtocolToView?.users.count ?? 0 {
            cell.showContent()
            cell.configureData(withUser: presenterProtocolToView?.users[indexPath.row])
        } else {
            cell.hideContent()
            if indexPath.row == presenterProtocolToView?.users.count ?? 0 {
                presenterProtocolToView?.getRandomUsers()
            }
        }
        return cell
    }
    
    /// After the initial download (while the `activityIndicatorView` is animating), refresh the data.
    @objc func tableViewPullToRefresh() {
        if !activityIndicatorView.isAnimating {
            presenterProtocolToView?.refresh(withDelay: refreshDelay)
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    /// If possible, go to the first cell.
    @objc func tableViewGoToTop() {
        if tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    /// After a cell get selected, show the details.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: RandomUserTableViewCell = tableView.cell(at: indexPath)
        cell.userImage.heroID = HeroIDs.imageEnlarging.rawValue
        cell.userName.heroID = HeroIDs.textEnlarging.rawValue
        presenterProtocolToView?.showRandomUserDetailsController(selected: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Additional UI-related functions, methods.
extension RandomUsersViewController {
    
    /// Get called only once, setup the delegates, `UIRefreshControl`, etc.
    private func setupBackButtonOnNextVC() {
        navigationItem.backBarButtonItem = UIBarButtonItem.create()
    }
    
    /// In the top left corner write out "Top", and when the user clicks on it, the `UITableView` must go to the top.
    private func setupLeftBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem
            .create(title: "Top", target: self, action: #selector(tableViewGoToTop))
    }
    
    /// In the top right corner write out the number of the currently downloaded distinct named users.
    private func refreshUserCounter() {
        let title = "Users: \(presenterProtocolToView?.numberOfDistinctNamedPeople ?? 0)"
        navigationItem.rightBarButtonItem = UIBarButtonItem
            .create(title: title, isEnabled: false)
    }
    
    /// Get called only once, setup the delegates, `UIRefreshControl`, etc.
    private func setupTableViewAndRefreshing() {
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(tableViewPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.backgroundView = activityIndicatorView
    }
    
    private func stopAnimating() {
        refreshControl.endRefreshing()
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - RandomUserProtocol (reaction to the Presenter) part.
extension RandomUsersViewController: ViewProtocolToPresenter {
    
    /// Will be called if the refresh should be ended.
    func stopRefreshing() {
        stopAnimating()
        tableView.reloadData()
    }
    
    /// VIPER architecture.
    func injectPresenter(_ presenterProtocolToView: PresenterProtocolToView) {
        self.presenterProtocolToView = presenterProtocolToView
        self.presenterProtocolToView?.getCachedUsers()
    }
    
    /// After successfully filled the array of the data, stop the animation and animate the `UITableView`.
    func didRandomUsersAvailable() {
        stopAnimating()
        tableView.animateUITableView {
            self.presenterProtocolToView?.enableFetching()
        }
    }
    
    /// After started the refresh, hide the cells.
    func willRandomUsersRefresh() {
        UIView.transition(with: tableView, duration: refreshDelay, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        })
    }
    
    /// After an error occured, show it to the user.
    func didErrorOccuredWhileDownload(errorMessage: String) {
        stopAnimating()
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    /// After the paging done, show the new cells (reload the data).
    func didEndRandomUsersPaging() {
        tableView.reloadData()
    }
}
