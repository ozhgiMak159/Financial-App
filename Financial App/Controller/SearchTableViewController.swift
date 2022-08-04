//
//  SearchTableViewController.swift
//  Financial App
//
//  Created by Maksim  on 04.08.2022.
//

import UIKit

class SearchTableViewController: UITableViewController {
  
    private lazy var searcheController: UISearchController = {
       let viewController = UISearchController(searchResultsController: nil)
        viewController.searchResultsUpdater = self
        viewController.delegate = self
        viewController.obscuresBackgroundDuringPresentation = false
        viewController.searchBar.placeholder = "Enter a company name or symbol"
        viewController.searchBar.autocapitalizationType = .allCharacters
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    
    private func setupNavigationBar() {
        navigationItem.searchController = searcheController
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    
}
