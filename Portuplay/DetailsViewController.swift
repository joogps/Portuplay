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
    
    let sections = ["Objetivo", "Para concluir", "Tempo por questão", "Concluído", ""]
    var labels: [String] = []
    
    var difficultyIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        difficultyPicker.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
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
            transition.duration = 1
            self.navigationController?.view.layer.add(transition, forKey: CATransitionType.push.rawValue)
            
            self.navigationController?.pushViewController(blackViewController, animated: false)
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
    
    var hideStatusBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.isNavigationBarHidden = true
        
        self.view.backgroundColor = .black
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let countdownViewController = storyboard.instantiateViewController(withIdentifier: "Countdown") as! CountdownViewController
            
            countdownViewController.desafio = self.desafio
            countdownViewController.difficultyIndex = self.difficultyIndex
            
            let transition = CATransition()
            transition.timingFunction = CAMediaTimingFunction(name:
                .easeInEaseOut)
            transition.type = .fade
            transition.duration = 1
            self.navigationController?.view.layer.add(transition, forKey: CATransitionType.push.rawValue)
            
            self.navigationController?.pushViewController(countdownViewController, animated: false)
        }
        
        hideStatusBar = true
        UIView.animate(withDuration: 1) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
}
