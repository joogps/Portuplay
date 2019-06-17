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
    var time: Int
    
    var phrases: [String]
    var select: [[JSON]]
    
    init(_ obj: JSON) {
        title = obj["title"].string!
        goal = obj["goal"].string!
        difficulty = obj["difficulty"].string!
        time = obj["time"].int!
        
        phrases = Array()
        select = Array()
        
        for item in obj["phrases"].array! {
            phrases.append(item["total"].string!)
            select.append(item["select"].array!)
        }
    }
}
