//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 05.05.2021..
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       initialSetup()
    }
    
    func initialSetup() {
        //removes border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //sets the background color to the same as the rest of the screen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        
        let titleItem = UILabel()
        titleItem.text = "PopQuiz"
        titleItem.textColor = .white
        titleItem.font = titleItem.font.withSize(20)
        navigationItem.titleView = titleItem
    }
    
    @IBAction func logoutClicked(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Token")
        defaults.removeObject(forKey: "UserId")
        
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        sceneDelegate?.goToLogin()
    }
    
}
