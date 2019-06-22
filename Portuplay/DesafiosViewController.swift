//
//  DesafiosViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit
import SwiftyJSON

class DesafiosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var desafiosTable: UITableView!
    var desafios: [Desafio] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredDesafios: [Desafio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        for file in files {
            if UserDefaults.standard.object(forKey: file) as? Data != nil {
                if let data = UserDefaults.standard.value(forKey: file) as? Data {
                    desafios.append(try! PropertyListDecoder().decode(Desafio.self, from: data))
                }
            } else {
                let path = Bundle.main.path(forResource: file, ofType: "json")
                let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
                let json = try? JSON(data: data!)
                
                let title = json?["title"].string!
                let goal = json?["goal"].string!
                let correct = json?["correct"].array!
                let time = json?["time"].array!
                
                var phrases = [String]()
                var answers = [[String]]()
                
                for item in (json?["phrases"].array!)! {
                    phrases.append(item["total"].string!)
                    
                    var answer: [String] = Array()
                    for ans in item["answer"].array! {
                        answer.append(ans.string!)
                    }
                    
                    answers.append(answer)
                }
                
                let desafio = Desafio(title!, goal!, correct!, time!, phrases, answers, fileName: file)
                
                defaults.set(try? PropertyListEncoder().encode(desafio), forKey: desafio.fileName)
                
                desafios.append(desafio)
            }
        }
        
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
}

extension DesafiosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
