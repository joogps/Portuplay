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
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameScore: UILabel!
    @IBOutlet weak var timeIndicator: TimeIndicator!
    @IBOutlet weak var wordList: TagListView!
    
    @IBOutlet weak var gameStackView: UIStackView!
    
    var desafio: Desafio? = nil
    var answers: [String] = Array()
    
    var score = 0;
    
    let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.isNavigationBarHidden = true
        
        gameTitle.text = desafio!.title
        self.gameScore.text = String(format: "%0"+String(String(self.desafio!.correct).count)+"d", self.score)+" / "+String(self.desafio!.correct)
        
        let bodyMonospacedNumbersFontDescriptor = bodyFontDescriptor.addingAttributes(
            [
                UIFontDescriptor.AttributeName.featureSettings: [
                    [
                        UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                        UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
                    ]
                ]
            ])
        
        gameScore.font = UIFont(descriptor: bodyMonospacedNumbersFontDescriptor, size: 20.0)
        gameScore.adjustsFontSizeToFitWidth = true
        
        gameStackView.setCustomSpacing(25, after: gameScore)
        gameStackView.setCustomSpacing(45, after: timeIndicator)
        
        wordList.textFont = UIFont.systemFont(ofSize: 24)
        wordList.alignment = .center
        
        timeIndicator.gameOverTime = Double(desafio!.time)
        timeIndicator.timeLabel.text = String(Int(timeIndicator.gameOverTime))
        
        timeIndicator.parentView = self
        
        addPhrase(Int.random(in: 0 ..< desafio!.phrases.count) )
        
    }
    
    func addPhrase(_ index: Int) {
        var phrase = desafio!.phrases[index]
        
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
                    
                    let gameover = !(self.desafio?.answers[index].contains(tag.titleLabel!.text!))!
                    
                    self.timeIndicator.timer.invalidate()
                    
                    if gameover {
                        UIApplication.shared.beginIgnoringInteractionEvents()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(900)) {
                            self.gameOver()
                        }
                    } else {
                        self.answers.append(tag.titleLabel!.text!)
                        
                        let correct =  self.desafio?.answers[index].count == self.answers.count && self.desafio?.answers[index].sorted() == self.answers.sorted()
                        
                        if correct {
                            UIApplication.shared.beginIgnoringInteractionEvents()
                            
                            self.score += 1
                            
                            let animation = {
                                self.gameScore.text = String(format: "%0"+String(String(self.desafio!.correct).count)+"d", self.score)+" / "+String(self.desafio!.correct)
                            }
                            
                            UIView.transition(with: self.gameScore, duration: 0.5, options: .transitionCrossDissolve, animations: animation, completion: nil)
                            
                            if self.score == self.desafio!.correct {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(900)) {
                                    self.complete()
                                }
                            }
                            else {
                                self.newPhrase()
                            }
                        }
                    }
                    
                    let color =  !gameover ?
                        UIColor(red: 0.56, green: 1.00, blue: 0.23, alpha:1.0) :
                        UIColor(red: 1.00, green: 0.35, blue: 0.45, alpha:1.0)
                    
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
    
    func newPhrase() {
        UIView.animate(withDuration: 0.9, animations: { () -> Void in
            self.wordList.alpha = 0
            self.timeIndicator.alpha = 0
        }, completion: { (finished: Bool) in
            self.wordList.removeAllTags()
            self.addPhrase(Int.random(in: 0 ..< self.desafio!.phrases.count))
            
            self.timeIndicator.time = 0
            
            self.timeIndicator.timeIndicator.strokeEnd = 1
            self.timeIndicator.timeLabel.text = String(Int(self.timeIndicator.gameOverTime))
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                self.wordList.alpha = 1
                self.timeIndicator.alpha = 1
            }, completion: { (finished: Bool) in
                self.timeIndicator.setTimer()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        })
    }
    
    func gameOver() {
        let gameOverViewController: GameOverViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameOver") as! GameOverViewController
        
        gameOverViewController.statusText = "GAME OVER"
        gameOverViewController.scoreText = self.gameScore.text!
        
        self.navigationController?.pushViewController(gameOverViewController, animated: true)
    }
    
    func complete() {
        let gameOverViewController: GameOverViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameOver") as! GameOverViewController
        
        gameOverViewController.statusText = "DESAFIO CONCLUÍDO"
        gameOverViewController.scoreText = self.gameScore.text!
        
        self.navigationController?.pushViewController(gameOverViewController, animated: true)
    }
}
