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
    
    @IBOutlet weak var loginFailedLabel: UILabel!
    
    var networkService : NetworkServiceProtocol?
    
    var response : LoginResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService = NetworkService()
        
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
        loginUser(username: loginField.text!, password: passwordField.text!)
        print("!!!")
    }
    
    func loginUser(username : String, password : String) {
        DispatchQueue.global().async {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "iosquiz.herokuapp.com"
            urlComponents.path = "/api/session"
            
            let queryItems = [URLQueryItem(name: "username", value: username), URLQueryItem(name: "password", value: password)]
            urlComponents.queryItems = queryItems
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            self.networkService!.executeUrlRequest(request) {(result: Result<LoginResponse, RequestError>) in
                print("!!")
                switch result {
                case .failure(_):
                    self.loginFailedLabel.text = "Username or password incorrect."
                    self.loginFailedLabel.isHidden = false
                case .success(let value):
                    print("usao")
                    let defaults = UserDefaults.standard
                    defaults.set(value.token, forKey: "Token")
                    defaults.set(value.user_id, forKey: "UserId")
                    self.completed(value: value)
                }
            }
        }
    }
    
    func completed(value : LoginResponse) {
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        sceneDelegate?.goToApp()
    }

    
}
