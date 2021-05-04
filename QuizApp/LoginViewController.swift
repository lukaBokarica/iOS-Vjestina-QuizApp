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
        print(loginResult)
    }
    
}
