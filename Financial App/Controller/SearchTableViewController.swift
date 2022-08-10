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
    //case resum
}

class SearchTableViewController: UITableViewController, UIAnimatable {
  
    private lazy var searchController: UISearchController = {
       let viewController = UISearchController(searchResultsController: nil)
        viewController.searchResultsUpdater = self
        //viewController.delegate = self
        viewController.obscuresBackgroundDuringPresentation = false
        viewController.searchBar.placeholder = "Enter a company name or symbol"
        viewController.searchBar.autocapitalizationType = .allCharacters
        return viewController
    }()
    
    private var subscribes = Set<AnyCancellable>()
    private var searchResults: SearchResults?
    private var one = SearchPlaceholderView()
    
    @Published private var searchQuery: String = ""
    @Published private var mode: Mode = .onboarding
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        observeFormSearchQuery()
        observeFormMode()
        setDelegate()
    }
    
    private func setDelegate() {
        searchController.delegate = self
      //  searchController.searchBar.delegate = self
    }
    
    
    private func observeFormSearchQuery() {
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] searchQuery in
                guard !searchQuery.isEmpty else { return }
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
                    self.tableView.isScrollEnabled = true
                }.store(in: &self.subscribes)
            }.store(in: &subscribes)
    }
    
    
    
    
    private func observeFormMode() {
        $mode.sink { [unowned self] (mode) in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                self.tableView.backgroundView?.isHidden = true
            }
            
        }.store(in: &subscribes)
        
    }
    
    
    
    
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    // ??
    private func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
    }
    
    private func handleSelection(for symbol: String, searchResult: SearchResult) {
        showLoadingAnimation()
        NetworkManager.shared.fetchTimeSeriesMonthlyAdjustedPublisher(keywords: symbol)
            .sink { [weak self] completionResult in
                self?.hideLoadingAnimation()
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] timeSeriesMonthlyAdjusted in
                self?.hideLoadingAnimation()
                let asset = Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
                self?.performSegue(withIdentifier: "showCalculator", sender: asset)
                self?.searchController.searchBar.text = nil
                
                // при переходе действия
            }.store(in: &subscribes)
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        if let searchResults = searchResults {
            let searchResult = searchResults.items[indexPath.row]
            cell.configure(with: searchResult)
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = searchResults {
            let searchResult = searchResults.items[indexPath.item]
            let symbol = searchResult.symbol
            handleSelection(for: symbol, searchResult: searchResult)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalculator",
            let destination = segue.destination as? CalculatorTableViewController,
            let asset = sender as? Asset {
                destination.asset = asset
        }
        
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

extension SearchTableViewController: UISearchBarDelegate {
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        one.imageView.isHidden = true
//        self.tableView.backgroundView = SearchPlaceholderView()
//    }
    
}
