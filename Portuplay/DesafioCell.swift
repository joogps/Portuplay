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
    
    func setDesafio(_ desafio: Desafio) {
        title.text = desafio.title
        subtitle.text = desafio.difficulty
        
        if !desafio.completed {
            let radius: CGFloat = 4
            let dotPath = UIBezierPath(arcCenter: CGPoint(x: UIScreen.main.bounds.width-radius-20, y: self.center.y-radius*2), radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
            
            let dot = CAShapeLayer()
            dot.path = dotPath.cgPath
            
            dot.fillColor = self.tintColor.cgColor
            dot.strokeColor = UIColor.clear.cgColor
            dot.lineWidth = 3.0
            
            self.layer.addSublayer(dot)
        }
    }
}
