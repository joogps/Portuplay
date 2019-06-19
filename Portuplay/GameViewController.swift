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
    
    var desafio: Desafio? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.isNavigationBarHidden = true
        
        wordList.textFont = UIFont.systemFont(ofSize: 23)
        wordList.alignment = .center
        
        let words = desafio!.phrases[0].components(separatedBy: " ")
        
        for word in words {
            let tag = wordList.addTag(word)
            
            tag.layer.transform = CATransform3DMakeTranslation(0, -3, 0)
            
            tag.onTap = { tag in
                let move = CABasicAnimation(keyPath: "transform")
                move.fromValue = tag.layer.transform
                move.toValue = CATransform3DMakeTranslation(0, 0, 0)
                move.duration = 0.2
                tag.layer.add(move, forKey: move.keyPath)
                tag.layer.transform = move.toValue as! CATransform3D
                
                let color = (self.desafio?.answers[0].contains(tag.titleLabel!.text!))! ? UIColor.green : UIColor.red
                
                let background = CABasicAnimation(keyPath: "backgroundColor")
                background.fromValue = tag.layer.backgroundColor
                background.toValue = color.cgColor
                background.duration = 0.6
                tag.layer.add(background, forKey: background.keyPath)
                
                tag.tagBackgroundColor = UIColor(cgColor: background.toValue as! CGColor)
            }
        }
    }
}
