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
    @IBOutlet weak var gameDifficulty: UILabel!
    @IBOutlet weak var gameScore: UILabel!
    @IBOutlet weak var timeIndicator: TimeIndicator!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var wordList: TagListView!
    
    @IBOutlet weak var gameStackView: UIStackView!
    
    var desafio: Desafio? = nil
    var difficultyIndex = 0
    
    var answers: [String] = Array()
    
    var alreadySelected: [Int] = Array()
    
    var score = 0;
    
    let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.isNavigationBarHidden = true
        
        gameTitle.text = desafio!.title
        self.gameScore.text = String(self.score)+" / "+String(self.desafio!.correct[difficultyIndex])
        
        gameDifficulty.text = ["Fácil", "Médio", "Difícil"][difficultyIndex]
        
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
        
        gameStackView.setCustomSpacing(10, after: gameTitle)
        gameStackView.setCustomSpacing(20, after: gameDifficulty)
        gameStackView.setCustomSpacing(40, after: gameScore)
        gameStackView.setCustomSpacing(40, after: timeIndicator)
        
        wordList.textFont = UIFont.systemFont(ofSize: 22.0)
        wordList.alignment = .center
        
        timeIndicator.gameOverTime = Double(desafio!.time[difficultyIndex])
        timeIndicator.timeLabel.text = String(Int(timeIndicator.gameOverTime))
        
        timeIndicator.parentView = self
        
        addPhrase(Int.random(in: 0 ..< desafio!.unselectedPhrases.count))
    }
    
    override func viewDidLayoutSubviews() {
        wordList.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: wordList.frame.height)
    }
    
    func addPhrase(_ i: Int) {
        let index = desafio!.unselectedPhrases[i]
        
        desafio!.unselectedPhrases.remove(at: i)
        alreadySelected.append(index)
        
        if desafio!.unselectedPhrases.count == 0 {
            desafio!.unselectedPhrases = Array(0 ..< desafio!.phrases.count)
            
            if desafio!.unselectedPhrases.count >= alreadySelected.count*2 {
                desafio!.unselectedPhrases = Array(Set(desafio!.unselectedPhrases).subtracting(alreadySelected))
            }
        }
        
        defaults.set(try? PropertyListEncoder().encode(desafio), forKey: desafio!.fileName)
        
        var phrase = desafio!.phrases[index]
        
        let special = ".!?,"
        
        var offset = 0
        for (i, char) in phrase.total.enumerated() {
            if special.contains(char) {
                phrase.total.insert(" ", at: phrase.total.index(phrase.total.startIndex, offsetBy: i+offset))
                offset += 1
            }
        }
        
        let words = phrase.total.components(separatedBy: .whitespaces)
        
        print(phrase.total, phrase.answer)
        
        for word in words {
            let tag = wordList.addTag(String(word))
            
            if (!special.contains(word)) {
                tag.onTap = { tag in
                    let move = CABasicAnimation(keyPath: "transform")
                    move.fromValue = tag.layer.transform
                    move.toValue = CATransform3DMakeTranslation(0, 3, 0)
                    move.duration = 0.1
                    tag.layer.add(move, forKey: move.keyPath)
                    tag.layer.transform = move.toValue as! CATransform3D
                    
                    let gameover = !(phrase.answer.contains(tag.titleLabel!.text!))
                    
                    if gameover {
                        UIApplication.shared.beginIgnoringInteractionEvents()
                        self.timeIndicator.timer.invalidate()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                            self.gameOver()
                        }
                    } else {
                        self.answers.append(tag.titleLabel!.text!)
                        
                        let correct =  phrase.answer.count == self.answers.count && phrase.answer.sorted() == self.answers.sorted()
                        
                        if correct {
                            UIApplication.shared.beginIgnoringInteractionEvents()
                            self.timeIndicator.timer.invalidate()
                            
                            self.score += 1
                            
                            let animation = {
                                self.gameScore.text = String(self.score)+" / "+String(self.desafio!.correct[self.difficultyIndex])
                            }
                            
                            UIView.transition(with: self.gameScore, duration: 0.5, options: .transitionCrossDissolve, animations: animation, completion: nil)
                            
                            if self.score == self.desafio!.correct[self.difficultyIndex] {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                                    self.complete()
                                }
                            }
                            else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                    self.newPhrase()
                                }
                            }
                        }
                    }
                    
                    let color =  !gameover ?
                        UIColor(red: 0.56, green: 1.00, blue: 0.23, alpha: 1.0) :
                        UIColor(red: 1.00, green: 0.0, blue: 0.0, alpha: 1.0)
                    
                    let backgroundColor = CABasicAnimation(keyPath: "backgroundColor")
                    backgroundColor.fromValue = tag.layer.backgroundColor
                    backgroundColor.toValue = color.cgColor
                    backgroundColor.duration = 0.6
                    tag.layer.add(backgroundColor, forKey: backgroundColor.keyPath)
                    
                    tag.tagBackgroundColor = UIColor(cgColor: backgroundColor.toValue as! CGColor)
                    
                    if gameover {
                        tag.textColor = .white
                    }
                }
            } else {
                tag.layer.transform = CATransform3DMakeTranslation(0, 3, 0)
            }
        }
    }
    
    func newPhrase() {
        answers = Array()
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.origin.x = -self.view.frame.width/2-self.wordList.frame.width
            self.timeIndicator.alpha = 0
        }, completion: { (finished: Bool) in
            self.wordList.removeAllTags()
            self.scrollView.frame.origin.x = self.view.frame.width/2+self.scrollView.frame.width
            
            self.addPhrase(Int.random(in: 0 ..< self.desafio!.unselectedPhrases.count))
            
            self.timeIndicator.time = 0
            
            self.timeIndicator.timeIndicator.strokeEnd = 1
            self.timeIndicator.timeLabel.text = String(Int(self.timeIndicator.gameOverTime))
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.scrollView.frame.origin.x = 0
                self.timeIndicator.alpha = 1
            }, completion: { (finished: Bool) in
                self.timeIndicator.setTimer()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        })
    }
    
    func gameOver() {
        let gameOverViewController: GameOverViewController = self.self.storyboard?.instantiateViewController(withIdentifier: "GameOver") as! GameOverViewController
        
        gameOverViewController.statusText = "GAME OVER"
        gameOverViewController.scoreText = self.gameScore.text!
        
        self.navigationController?.pushViewController(gameOverViewController, animated: true)
    }
    
    func complete() {
        let gameOverViewController: GameOverViewController = self.self.storyboard?.instantiateViewController(withIdentifier: "GameOver") as! GameOverViewController
        
        gameOverViewController.statusText = "DESAFIO CONCLUÍDO"
        gameOverViewController.scoreText = self.gameScore.text!
        
        desafio!.concluded[difficultyIndex] = true
        defaults.set(try? PropertyListEncoder().encode(desafio), forKey: desafio!.fileName)
        
        self.navigationController?.pushViewController(gameOverViewController, animated: true)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let alert = UIAlertController(title: "Sair do desafio?", message: "Você não poderá recuperar o seu progresso.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: {
                action in
                let desafiosViewController = self.storyboard?.instantiateViewController(withIdentifier: "Desafios") as! DesafiosViewController
                
                let transition = CATransition()
                transition.timingFunction = CAMediaTimingFunction(name:
                    CAMediaTimingFunctionName.easeInEaseOut)
                transition.type = .push
                transition.subtype = .fromTop
                transition.duration = 0.35
                self.navigationController?.view.layer.add(transition, forKey: CATransitionType.push.rawValue)
                
                self.navigationController?.pushViewController(desafiosViewController, animated: false)
                
                self.timeIndicator.timer.invalidate()
            }))
            alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
}
