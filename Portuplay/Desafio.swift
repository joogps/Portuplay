//
//  Desafio.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import Foundation

struct Desafio: Codable {
    var title: String
    var goal: String
    var correct: [Int]
    var time: [Int]
    
    var phrases: [String]
    var answers: [[String]]
    
    var concluded: [Bool]
    
    var unselectedPhrases: [Int]
    
    var fileName: String
    
    init(_ title: String, _ goal: String, _ correct: [Int], _ time: [Int], _ phrases: [String], _ answers: [[String]], fileName: String) {
        self.title = title
        self.goal = goal
        self.correct = correct
        self.time = time
        
        self.phrases = phrases
        self.answers = answers
        
        self.concluded = Array(repeating: false, count: 3)
        
        self.unselectedPhrases = Array(0 ..< phrases.count)
        
        self.fileName = fileName
    }
}
