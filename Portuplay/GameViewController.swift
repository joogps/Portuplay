//
//  GameViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 14/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit
import TagListView

class GameViewController: UIViewController {
    @IBOutlet weak var wordList: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.isNavigationBarHidden = true;
        
        wordList.textFont = UIFont.systemFont(ofSize: 24)
        wordList.alignment = .center
        
        wordList.addTags(["Bla", "BlaBlaBla", "BlaBla"])
    }
    
    func setGame (_ desafio: Desafio) {
        
    }
}
