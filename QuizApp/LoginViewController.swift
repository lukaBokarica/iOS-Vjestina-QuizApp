//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 13.04.2021..
//

import UIKit

class LoginViewController: UIViewController {
        
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //removes border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //sets the background color to the same as the rest of the screen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemIndigo

    }
    
    @IBAction func usernameFieldSelected(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.red.cgColor
        sender.layer.borderWidth += 1
    }
    
    @IBAction func usernameFieldDeselected(_ sender: UITextField) {
        sender.layer.borderWidth -= 1
    }
    
    @IBAction func passwordFieldSelected(_ sender: UITextField) {
        sender.layer.borderColor = UIColor.red.cgColor
        sender.layer.borderWidth += 1
    }
    
    @IBAction func passwordFieldDeselected(_ sender: UITextField) {
        sender.layer.borderWidth -= 1
    }

    @IBAction func passwordEditingChanged(_ sender: UITextField) {
        if(!loginField.text!.elementsEqual("") && passwordField.text! != "") {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        //print("i was clicked!")
        let loginResult = DataService().login(email: loginField.text!, password: passwordField.text!)
        //print(loginResult)
        
        switch loginResult {
        case LoginStatus.success:
            let vc = QuizzesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print(loginResult)
        }
    }
    
}
