//
//  Desafio.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Desafio:Codable {
    var title: String
    var goal: String
    var difficulty: String
    var correct: Int
    var time: Int
    
    var phrases: [String]
    var answers: [[String]]
    
    var complete: Bool = false
    
    var fileName: String = String()
}
