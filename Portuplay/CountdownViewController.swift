//
//  CountdownViewController.swift
//  
//
//  Created by João Gabriel Pozzobon dos Santos on 21/06/19.
//

import UIKit

class CountdownViewController: UIViewController {
    @IBOutlet weak var countdownLabel: UILabel!
    
    var countdown = 3
    
    var timer = Timer()
    
    var desafio: Desafio? = nil
    var difficultyIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        
        self.navigationController!.isNavigationBarHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.updateCountdown()
        }
    }
    
    @objc func updateCountdown() {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromTop
        transition.duration = 0.3
        
        if countdown >= 1 {
            countdownLabel.layer.add(transition, forKey: CATransitionType.push.rawValue)
            
            countdownLabel.text = String(countdown)
            
            countdown -= 1
        } else {
            let gameViewController: GameViewController = self.storyboard?.instantiateViewController(withIdentifier: "Game") as! GameViewController
            
            gameViewController.desafio = desafio
            gameViewController.difficultyIndex = difficultyIndex!
            
            transition.duration = 0.5
            self.navigationController?.view.layer.add(transition, forKey: CATransitionType.push.rawValue)
            
            self.navigationController?.pushViewController(gameViewController, animated: false)
            
            timer.invalidate()
        }
    }
}
