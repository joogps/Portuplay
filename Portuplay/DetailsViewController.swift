//
//  DetailViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 09/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setDetails (_ desafio: Desafio) {
        self.title = desafio.title
        
    }
}
