//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Pero Bokarica on 13.04.2021..
//

import UIKit

class LoginViewController: UIViewController {
        
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var username : String = ""
    
    var password : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.isEnabled = false
        //view.backgroundColor = .magenta
    }
    
    @IBAction func usernameEntered(_ sender: UITextField) {
        username = sender.text!
    }

    @IBAction func passwordEditingChanged(_ sender: UITextField) {
        if(!username.elementsEqual("") && passwordField.text != "") {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        //print("i was clicked!")
        password = passwordField.text!
        let loginResult = DataService().login(email: username, password: password)
        //print(username)
        //print(password)
        print(loginResult)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
