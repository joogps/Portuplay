//
//  InfoViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 23/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit
import AcknowList

class InfoViewController: UIViewController {
    @IBOutlet weak var appIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if allConcluded {
            appIcon.image = UIImage(named: "GoldenAppIcon@3x")
        } else {
            appIcon.image = UIImage(named: "AppIcon@3x")
        }
        
        appIcon.layer.borderColor = UIColor.lightGray.cgColor
        appIcon.layer.borderWidth = 1
        appIcon.layer.cornerRadius = 10/57*appIcon.frame.width
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class InfoTableViewController: UITableViewController {
    @IBOutlet var infoTable: UITableView!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                guard let url = URL(string: "https://github.com/joogps/Portuplay") else { return }
                UIApplication.shared.open(url)
            } else if indexPath.row == 1 {
                let twitter = URL(string: "twitter://user?screen_name=joogps")!
                let web = URL(string: "https://www.twitter.com/joogps")!
                UIApplication.shared.open(UIApplication.shared.canOpenURL(twitter) ? twitter : web, options: [:], completionHandler: nil)
            }
        } else if indexPath.section == 1 {
            let acknowListViewController = AcknowListViewController()
            acknowListViewController.title = "Créditos"
            acknowListViewController.footerText = ""
            
            let parentDesafiosViewController = self.presentingViewController?.children.last as! DesafiosViewController
            
            self.dismiss(animated: true, completion: { () -> Void in
                let acknowListNavigationController = UINavigationController(rootViewController: acknowListViewController)
                acknowListNavigationController.navigationBar.prefersLargeTitles = true
                
                parentDesafiosViewController.present(acknowListNavigationController
                    , animated: true, completion: nil)
            })
            
    
        } else {
            let alert = UIAlertController(title: "Apagar dados?", message: "Essa ação não poderá ser desfeita.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: {
                action in
                
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UserDefaults.standard.synchronize()
                
                createDesafios()
                
                allConcluded = false
                
                if UIApplication.shared.supportsAlternateIcons {
                    UIApplication.shared.setAlternateIconName(nil)
                }
                
                (self.presentingViewController?.children.last as! DesafiosViewController).desafiosTable.reloadData()
                
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
        
        infoTable.deselectRow(at: indexPath, animated: true)
    }
}
