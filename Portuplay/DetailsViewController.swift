//
//  DetailsViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 13/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var detailsTable: UITableView!
    
    var desafio: Desafio? = nil
    
    let sections = ["OBJETIVO", "DIFICULDADE", "PARA GANHAR", "TEMPO POR QUESTÃO", "COMPLETO", ""]
    var labels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setDetails(_ desafio: Desafio) {
        self.desafio = desafio
        
        let title = desafio.title
        let goal = desafio.goal
        let difficulty = desafio.difficulty
        let correct = desafio.correct
        let time = desafio.time
        let complete = desafio.complete
        
        self.title = title
        labels.append(goal)
        labels.append(difficulty)
        labels.append(String(correct)+" acertos seguidos")
        labels.append(String(time)+" segundos")
        labels.append(complete ? "Sim" : "Não")
        
        labels.append("Jogar")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? UITableViewCell
        
        let text = labels[indexPath.section]
        cell?.textLabel?.text = text
        cell?.textLabel?.numberOfLines = 0
        
        if text == "Jogar" {
            cell?.textLabel?.textColor = self.view.tintColor
        } else {
            cell?.selectionStyle = .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if labels[indexPath.row] == "Jogar" {
            let gameViewController: GameViewController = storyboard?.instantiateViewController(withIdentifier: "Game") as! GameViewController
            
            gameViewController.desafio = desafio
            
            self.navigationController?.pushViewController(gameViewController, animated: true)
            
            detailsTable.deselectRow(at: indexPath, animated: true)
        }
    }
}
