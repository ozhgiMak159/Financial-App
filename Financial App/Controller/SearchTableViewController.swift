//
//  SearchTableViewController.swift
//  Financial App
//
//  Created by Maksim  on 04.08.2022.
//

import UIKit
import Combine
import MBProgressHUD

enum Mode {
    case onboarding
    case search
}

class SearchTableViewController: UITableViewController, UIAnimatable {
  
    private lazy var searcheController: UISearchController = {
       let viewController = UISearchController(searchResultsController: nil)
        viewController.searchResultsUpdater = self
        viewController.delegate = self
        viewController.obscuresBackgroundDuringPresentation = false
        viewController.searchBar.placeholder = "Enter a company name or symbol"
        viewController.searchBar.autocapitalizationType = .allCharacters
        return viewController
    }()
    
    private var subscribes = Set<AnyCancellable>()
    private var searchResults: SearchResults?
    
    @Published private var mode: Mode = .onboarding
    @Published private var searchQuery = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        observeFormSearchQuery()
        observeFormMode()
    }
    
    private func observeFormSearchQuery() {
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] searchQuery in
                showLoadingAnimation()
                    NetworkManager.shared.fetchData(keywords: searchQuery).sink { completion in
                    hideLoadingAnimation()
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { searchResults in
                    self.searchResults = searchResults
                    self.tableView.reloadData()
                }.store(in: &self.subscribes)
            }.store(in: &subscribes)
    }
    
    
    private func observeFormMode() {
        $mode.sink { [unowned self] (mode) in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                self.tableView.backgroundView = nil
            }
            
        }.store(in: &subscribes)
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searcheController
        navigationItem.title = "Search"
    }
    // ??
    private func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        if let searchResults = searchResults {
            let searcheResult = searchResults.items[indexPath.row]
            cell.configure(with: searcheResult)
            
        }
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        self.searchQuery = searchQuery
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
}
