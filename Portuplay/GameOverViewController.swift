//
//  GameOverViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 19/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var voltar: UIButton!
    
    var statusText = ""
    var scoreText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        status.text = statusText
        score.text = scoreText
        voltar.layer.cornerRadius = 6
        
        var colorTop: CGColor? = nil
        var colorBottom: CGColor? = nil
        
        if statusText == "GAME OVER" {
            colorTop =  UIColor.orange.cgColor
            colorBottom = UIColor.red.cgColor
        } else if statusText == "DESAFIO CONCLUÍDO" {
            colorTop =  UIColor.cyan.cgColor
            colorBottom = UIColor.green.cgColor
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [-0.5, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
