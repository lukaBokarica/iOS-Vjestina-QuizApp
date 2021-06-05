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
    
    @IBOutlet weak var popQuizLabel: UILabel!
    
    private let loginPresenter = LoginPresenter(networkService: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter.setViewDelegate(loginViewDelegate: self)
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        popQuizLabel.alpha = 0
        popQuizLabel.transform.scaledBy(x: 0, y: 0)
        
        loginField.alpha = 0
        loginField.transform = loginField.transform.translatedBy(
            x: -view.frame.width,
            y: 0)
        
        passwordField.alpha = 0
        passwordField.transform = passwordField.transform.translatedBy(
            x: -view.frame.width,
            y: 0)
        
        loginButton.alpha = 0
        loginButton.transform = loginButton.transform.translatedBy(
            x: -view.frame.width,
            y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            options: [ .curveEaseInOut ],
            animations: {
                self.popQuizLabel.alpha = 1.0
                self.popQuizLabel.transform = .identity
            },
            completion: nil)
        
        UIView.animate(
            withDuration: 1.5,
            delay: 0.25,
            options: [ .curveEaseInOut ],
            animations: {
                self.loginField.alpha = 1
                self.loginField.transform = .identity
            }) { (completed) in
            UIView.animate(
                withDuration: 1.5,
                delay: 0.25,
                options: [ .curveEaseInOut ],
                animations: {
                    self.passwordField.alpha = 1
                    self.passwordField.transform = .identity
                }) {(completed) in
                UIView.animate(
                    withDuration: 1.5,
                    delay: 0.25,
                    options: [ .curveEaseInOut ],
                    animations: {
                        self.loginButton.alpha = 1
                        self.loginButton.transform = .identity
                    },
                    completion: nil)
            }
            }
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
        makeElementsDissapear()
    }
    
    func unsuccessfulLogin() {
        self.loginFailedLabel.text = "Username or password incorrect."
        self.loginFailedLabel.isHidden = false
    }
    
    func noInternetConnectionWarning() {
        self.loginFailedLabel.text = "No internet connection!"
        self.loginFailedLabel.isHidden = false
    }
    
    func makeElementsDissapear() {
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            options: [ .curveEaseInOut ],
            animations: {
                self.popQuizLabel.transform = self.popQuizLabel.transform.translatedBy(x: 0, y: -self.popQuizLabel.frame.maxY)
            }) {(completed) in
            UIView.animate(
                withDuration: 1.5,
                delay: 0.25,
                options: [ .curveEaseInOut ],
                animations: {
                    self.loginField.transform = self.loginField.transform.translatedBy(x: 0, y: -self.loginField.frame.maxY)
                }) { (completed) in
                UIView.animate(
                    withDuration: 1.5,
                    delay: 0.25,
                    options: [ .curveEaseInOut ],
                    animations: {
                        self.passwordField.transform = self.passwordField.transform.translatedBy(x: 0, y: -self.passwordField.frame.maxY)
                    }) {(completed) in
                    UIView.animate(
                        withDuration: 1.5,
                        delay: 0.25,
                        options: [ .curveEaseInOut ],
                        animations: {
                            self.loginButton.transform = self.loginButton.transform.translatedBy(x: 0, y: -self.loginButton.frame.maxY)
                        },
                        completion: {_ in
                            let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
                            sceneDelegate?.goToApp()
                        })
                }
                }
            }
    }
}
