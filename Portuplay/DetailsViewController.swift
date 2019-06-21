//
//  DetailsViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 13/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIToolbarDelegate {
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var difficultyPicker: UISegmentedControl!
    
    var desafio: Desafio? = nil
    
    let sections = ["OBJETIVO", "PARA CONCLUIR", "TEMPO POR QUESTÃO", "CONCLUÍDO", ""]
    var labels: [String] = []
    
    var difficultyIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setDetails(_ desafio: Desafio) {
        labels = []
        
        self.desafio = desafio
        
        let title = desafio.title
        let goal = desafio.goal
        let correct = desafio.correct[difficultyIndex].int!
        let time = desafio.time[difficultyIndex].int!
        let completed = desafio.concluded
        
        self.title = title
        labels.append(goal)
        labels.append(String(correct)+" acertos seguidos")
        labels.append(String(time)+" segundos")
        labels.append(completed[difficultyIndex] ? "Sim" : "Não")
        
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
            cell?.textLabel?.textColor = .darkText
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if labels[indexPath.section] == "Jogar" {
            let blackViewController: BlackViewController = BlackViewController()
            
            blackViewController.desafio = desafio
            blackViewController.difficultyIndex = difficultyIndex
            
            let transition = CATransition()
            transition.timingFunction = CAMediaTimingFunction(name:
                .easeInEaseOut)
            transition.type = .fade
            transition.duration = 0.5
            self.navigationController?.view.layer.add(transition, forKey: CATransitionType.push.rawValue)
            
            self.navigationController?.pushViewController(blackViewController, animated: false)
            
            detailsTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func updateDifficulty(_ sender: UISegmentedControl) {
        difficultyIndex = sender.selectedSegmentIndex
        setDetails(desafio!)
        detailsTable.reloadData()
    }
}

class BlackViewController: UIViewController {
    var desafio: Desafio? = nil
    var difficultyIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.isNavigationBarHidden = true
        
        self.view.backgroundColor = .black
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let countdownViewController: CountdownViewController = storyboard.instantiateViewController(withIdentifier: "Countdown") as! CountdownViewController
            
            countdownViewController.desafio = self.desafio
            countdownViewController.difficultyIndex = self.difficultyIndex
            
            let transition = CATransition()
            transition.timingFunction = CAMediaTimingFunction(name:
                .easeInEaseOut)
            transition.type = .fade
            transition.duration = 0.5
            self.navigationController?.view.layer.add(transition, forKey: CATransitionType.push.rawValue)
            
            self.navigationController?.pushViewController(countdownViewController, animated: false)
        })
    }
}
