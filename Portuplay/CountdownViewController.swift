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
    
    var hideStatusBar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.isNavigationBarHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1050)) {
            self.updateCountdown()
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
        }
        
        hideStatusBar = false
        UIView.animate(withDuration: 1) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @objc func updateCountdown() {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromTop
        transition.duration = 0.35
        
        if countdown >= 1 {
            countdownLabel.layer.add(transition, forKey: CATransitionType.push.rawValue)
            countdownLabel.text = String(countdown)
            
            countdown -= 1
        } else {
            let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "Game") as! GameViewController
            
            gameViewController.desafio = desafio
            gameViewController.difficultyIndex = difficultyIndex!
            
            transition.duration = 0.75
            self.navigationController?.view.layer.add(transition, forKey: CATransitionType.push.rawValue)
            
            self.navigationController?.pushViewController(gameViewController, animated: false)
            
            timer.invalidate()
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
}
