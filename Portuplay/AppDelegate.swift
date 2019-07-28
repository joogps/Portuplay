//
//  AppDelegate.swift
//  Portuplay
//
//  Created by João Gabriel Pozzobon dos Santos on 05/06/19.
//  Copyright © 2019 João Gabriel Pozzobon dos Santos. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard
let files = ["Adjetivos", "Advérbios", "Artigos", "Substantivos"]

var desafios: [Desafio] = []

var allConcluded = false

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
        if var desafio = createDesafio(file) {
            if UserDefaults.standard.object(forKey: file) as? Data != nil {
                let data = UserDefaults.standard.value(forKey: file) as? Data
                let desafioFromDefaults = try! PropertyListDecoder().decode(Desafio.self, from: data!)
                
                if desafio.phrases != desafioFromDefaults.phrases {
                    desafio.concluded = desafioFromDefaults.concluded
                } else {
                    desafio = desafioFromDefaults
                }
            }
            
            defaults.set(try? PropertyListEncoder().encode(desafio), forKey: desafio.fileName)
            desafios.append(desafio)
        }
    }
}

func createDesafio(_ file: String) -> Desafio? {
    if let path = Bundle.main.path(forResource: file, ofType: "plist") {
        let dict = NSDictionary(contentsOfFile: path)
        
        let title = dict?["título"] as! String
        let goal = dict?["objetivo"] as! String
        let correct = dict?["correto"] as! [Int]
        let time = dict?["tempo"] as! [Int]
        
        var phrases = [Phrase]()
        
        for phrase in dict?["frases"] as! [NSDictionary] {
            let total = phrase["total"] as! String
            let answer = phrase["resposta"] as! [String]
            
            phrases.append(Phrase(total, answer))
        }
        
        return Desafio(title, goal, correct, time, phrases, fileName: file)
    }
    
    return nil
}
