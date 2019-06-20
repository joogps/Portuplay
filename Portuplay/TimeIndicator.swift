//
//  TimeIndicator.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 19/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class TimeIndicator: UIView {
    let timeIndicator = CAShapeLayer()
    var timeLabel = UILabel()
    
    var timer = Timer()
    var time = 0.0
    
    var gameOverTime = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadTime()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        loadTime()
    }

    func loadTime() {
        setTimer()
        
        let circle = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: min(self.frame.width, self.frame.height)/2, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi*1.5, clockwise: true)
        
        timeIndicator.path = circle.cgPath
        
        timeIndicator.strokeColor = UIColor.black.cgColor
        timeIndicator.lineWidth = 10
        timeIndicator.fillColor = UIColor.clear.cgColor
        timeIndicator.lineCap = .round
        
        timeIndicator.strokeEnd = 1
        
        self.layer.addSublayer(timeIndicator)
        
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        timeLabel.textAlignment = .center
        timeLabel.textColor = .black
        timeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        self.addSubview(timeLabel)
    }
    
    @objc func updateTime() {
        time += 1
        timeLabel.text = String(Int(gameOverTime-time))
        timeIndicator.strokeEnd = CGFloat(1-(time/gameOverTime))
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
}
