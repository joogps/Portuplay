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
        
        for file in files {
            if UserDefaults.standard.object(forKey: file) != nil {
                if let data = UserDefaults.standard.value(forKey: file) as? Data {
                    desafios.append(try! PropertyListDecoder().decode(Desafio.self, from: data))
                }
            } else {
                let path = Bundle.main.path(forResource: file, ofType: "json")
                let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
                let json = try? JSON(data: data!)
                
                let title = json?["title"].string!
                let goal = json?["goal"].string!
                let difficulty = json?["difficulty"].string!
                let correct = json?["correct"].int!
                let time = json?["time"].int!
                
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
                
                let desafio = Desafio(title: title!, goal: goal!, difficulty: difficulty!, correct: correct!, time: time!, phrases: phrases, answers: answers, complete: false, fileName: file)
                
                defaults.set(try? PropertyListEncoder().encode(desafio), forKey: desafio.fileName)
                
                desafios.append(desafio)
            }
        }
        
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
        let detailsViewController: DetailsViewController = storyboard?.instantiateViewController(withIdentifier: "Details") as! DetailsViewController
        
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
