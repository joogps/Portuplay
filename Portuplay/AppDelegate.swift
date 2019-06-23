//
//  AppDelegate.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit
import SwiftyJSON

let defaults = UserDefaults.standard
let files = ["Substantivos", "Adjetivos", "Verbos"]

var desafios: [Desafio] = []

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        for file in files {
            let defaultValue = [file : ""]
            defaults.register(defaults: defaultValue)
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

func createDesafios() {
    desafios = Array()
    
    for file in files {
        if UserDefaults.standard.object(forKey: file) as? Data != nil {
            if let data = UserDefaults.standard.value(forKey: file) as? Data {
                desafios.append(try! PropertyListDecoder().decode(Desafio.self, from: data))
            }
        } else {
            let path = Bundle.main.path(forResource: file, ofType: "json")
            let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
            let json = try? JSON(data: data!)
            
            let title = json?["title"].string!
            let goal = json?["goal"].string!
            let correct = json?["correct"].array!
            let time = json?["time"].array!
            
            var phrases = [String]()
            var answers = [[String]]()
            
            for item in (json?["phrases"].array!)! {
                phrases.append(item["total"].string!)
                
                var answer: [String] = Array()
                for ans in item["answer"].array! {
                    answer.append(ans.string!)
                }
                
                answers.append(answer)
            }
            
            let desafio = Desafio(title!, goal!, correct!, time!, phrases, answers, fileName: file)
            
            defaults.set(try? PropertyListEncoder().encode(desafio), forKey: desafio.fileName)
            
            desafios.append(desafio)
        }
    }
}
