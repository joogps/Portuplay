//
//  DesafiosViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class DesafiosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var desafiosTable: UITableView!
    var desafios: [Desafio] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredDesafios: [Desafio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        desafios.append(Desafio(title: "Substantivos", subtitle: "Fácil"))
        desafios.append(Desafio(title: "Adjetivos", subtitle: "Intermediário"))
        desafios.append(Desafio(title: "Verbos", subtitle: "Fácil"))
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return filteredDesafios.count
        }
        
        return desafios.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DesafioCell") as? DesafioCell else {
            return UITableViewCell()
        }
        
        var desafio: Desafio
        
        if isSearching() {
            desafio = filteredDesafios[indexPath.row]
        } else {
            desafio = desafios[indexPath.row]
        }
        
        cell.setDesafio(desafio)
        
        return cell
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredDesafios = desafios.filter { $0.title.localizedCaseInsensitiveContains(searchText)}
        desafiosTable.reloadData()
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension DesafiosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
