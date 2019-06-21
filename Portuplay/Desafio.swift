//
//  Desafio.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Desafio: Codable {
    var title: String
    var goal: String
    var correct: [JSON]
    var time: [JSON]
    
    var phrases: [String]
    var answers: [[String]]
    
    var concluded: [Bool] = [false]
    
    var fileName: String = String()
    
    init(_ title: String, _ goal: String, _ correct: [JSON], _ time: [JSON], _ phrases: [String], _ answers: [[String]], fileName: String) {
        self.title = title
        self.goal = goal
        self.correct = correct
        self.time = time
        
        self.phrases = phrases
        self.answers = answers
        
        self.concluded = Array(repeating: false, count: 3)
        
        self.fileName = fileName
    }
}
