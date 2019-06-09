//
//  DesafioCell.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class DesafioCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func setDesafio (_ desafio: Desafio) {
        title.text = desafio.title
        subtitle.text = desafio.difficulty
    }
}
