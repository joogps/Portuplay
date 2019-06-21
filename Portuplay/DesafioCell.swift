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
    
    func setDesafio(_ desafio: Desafio) {
        title.text = desafio.title
        
        if desafio.concluded.contains(false) {
            let radius: CGFloat = 4

            let badgeView = UIView(frame: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
            let badgePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
            
            let badgeLayer = CAShapeLayer()
            badgeLayer.path = badgePath.cgPath
            badgeLayer.fillColor = self.tintColor.cgColor
            
            badgeView.layer.addSublayer(badgeLayer)
            
            self.accessoryView = badgeView
            self.accessoryType = .none
        }
    }
}
