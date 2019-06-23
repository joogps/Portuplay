//
//  DesafiosViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit
import SPStorkController

class DesafiosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var desafiosTable: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredDesafios: [Desafio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDesafios()
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        self.navigationController!.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        desafios = desafios.sorted(by: { $0.concluded.contains(false) && !$1.concluded.contains(false) })
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Details") as! DetailsViewController
        
        var desafio: Desafio
        
        if isSearching() {
            desafio = filteredDesafios[indexPath.row]
        } else {
            desafio = desafios[indexPath.row]
        }
        
        detailsViewController.setDetails(desafio)
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
        desafiosTable.deselectRow(at: indexPath, animated: true)
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
    
    @objc func infoButtonTapped() {
        let infoViewController = self.storyboard?.instantiateViewController(withIdentifier: "Info") as! InfoViewController
        infoViewController.view.backgroundColor = .white
        self.presentAsStork(infoViewController)
    }
    
    func didDismissStorkBySwipe() {
        desafiosTable.reloadData()
    }
    
    func didDismissStorkByTap() {
        desafiosTable.reloadData()
    }
}

extension DesafiosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
