//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 13.04.2021..
//

import UIKit

class LoginViewController: UIViewController, LoginViewDelegate {
        
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var loginFailedLabel: UILabel!
        
    private let loginPresenter = LoginPresenter(networkService: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter.setViewDelegate(loginViewDelegate: self)
        
        initialSetup()
    }
    
    func initialSetup() {
        loginField.text = "username"
        loginFailedLabel.isHidden = true
        //removes border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //sets the background color to the same as the rest of the screen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
    }
    
    @IBAction func usernameEditingChanged(_ sender: UITextField) {
        loginFailedLabel.isHidden = true
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
        loginFailedLabel.isHidden = true
        if(!loginField.text!.elementsEqual("") && passwordField.text! != "") {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        loginPresenter.loginUser(username: loginField.text!, password: passwordField.text!)
        //loginUser(username: loginField.text!, password: passwordField.text!)
    }
    
    func successfulLogin() {
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        sceneDelegate?.goToApp()
    }
    
    func unsuccessfulLogin() {
        self.loginFailedLabel.text = "Username or password incorrect."
        self.loginFailedLabel.isHidden = false
    }
    
    func noInternetConnectionWarning() {
        self.loginFailedLabel.text = "No internet connection!"
        self.loginFailedLabel.isHidden = false
    }
}
