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
    @IBOutlet weak var timeIndicator: TimeIndicator!
    
    var desafio: Desafio? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.isNavigationBarHidden = true
        
        wordList.textFont = UIFont.systemFont(ofSize: 24)
        wordList.alignment = .center
        
        var phrase = desafio!.phrases[0]
        
        let special = ".!?"
        
        for (i, char) in phrase.enumerated() {
            if  special.contains(char) {
                phrase.insert(" ", at: phrase.index(phrase.startIndex, offsetBy: i))
            }
        }
        
        let words = phrase.components(separatedBy: .whitespaces)
        
        for word in words {
            let tag = wordList.addTag(String(word))
            
            if (!special.contains(word)) {
                tag.layer.transform = CATransform3DMakeTranslation(0, -3, 0)
                
                tag.onTap = { tag in
                    let move = CABasicAnimation(keyPath: "transform")
                    move.fromValue = tag.layer.transform
                    move.toValue = CATransform3DMakeTranslation(0, 0, 0)
                    move.duration = 0.1
                    tag.layer.add(move, forKey: move.keyPath)
                    tag.layer.transform = move.toValue as! CATransform3D
                    
                    let color = (self.desafio?.answers[0].contains(tag.titleLabel!.text!))! ?
                        UIColor(red:0.56, green:1.00, blue:0.23, alpha:1.0) :
                        UIColor(red:1.00, green:0.42, blue:0.42, alpha:1.0)
                    
                    let background = CABasicAnimation(keyPath: "backgroundColor")
                    background.fromValue = tag.layer.backgroundColor
                    background.toValue = color.cgColor
                    background.duration = 0.6
                    tag.layer.add(background, forKey: background.keyPath)
                    
                    tag.tagBackgroundColor = UIColor(cgColor: background.toValue as! CGColor)
                }
            }
        }
        
        timeIndicator.gameOverTime = Double(desafio!.time)
        timeIndicator.timeLabel.text = String(Int(timeIndicator.gameOverTime))
    }
}
