//
//  Desafio.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import Foundation
import SwiftyJSON

class Desafio {
    var title: String
    var goal: String
    var difficulty: String
    var correct: Int
    var time: Int
    
    var phrases: [String]
    var answers: [[String]]
    
    init(_ obj: JSON) {
        title = obj["title"].string!
        goal = obj["goal"].string!
        difficulty = obj["difficulty"].string!
        correct = obj["correct"].int!
        time = obj["time"].int!
        
        phrases = Array()
        answers = Array()
        
        for item in obj["phrases"].array! {
            phrases.append(item["total"].string!)
            
            var answer: [String] = Array()
            for ans in item["answer"].array! {
                answer.append(ans.string!)
            }
            
            answers.append(answer)
        }
    }
}
