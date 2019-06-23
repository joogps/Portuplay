//
//  InfoViewController.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 23/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var appIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appIcon.image = .appIcon
        appIcon.layer.borderColor = UIColor.darkGray.cgColor
        appIcon.layer.borderWidth = 1
        appIcon.layer.cornerRadius = 10/57*appIcon.frame.width
    }
}

extension UIImage {
    static var appIcon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String:Any],
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String:Any],
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last else { return nil }
        return UIImage(named: lastIcon)
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
        } else {
        let alert = UIAlertController(title: "Apagar dados?", message: "Essa ação não pode ser desfeita.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: {
                action in
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                
                createDesafios()
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
        
        infoTable.deselectRow(at: indexPath, animated: true)
    }
}
