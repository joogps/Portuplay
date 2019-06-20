//
//  GameOverViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 19/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var voltar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        voltar.layer.cornerRadius = 4
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
