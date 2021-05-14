//
//  LoginPresenter.swift
//  QuizApp
//
//  Created by Luka Bokarica on 13.05.2021..
//

import UIKit

protocol LoginViewDelegate: NSObjectProtocol {
    func successfulLogin()
    func unsuccessfulLogin()
    func noInternetConnectionWarning()
}

class LoginPresenter {
    
    private let networkService: NetworkServiceProtocol
    
    weak private var loginViewDelegate : LoginViewDelegate?
        
    init(networkService:NetworkService){
        self.networkService = networkService
    }
    
    func setViewDelegate(loginViewDelegate:LoginViewDelegate?){
            self.loginViewDelegate = loginViewDelegate
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
            
            self.networkService.executeUrlRequest(request) {(result: Result<LoginResponse, RequestError>) in
                switch result {
                case .failure(let error):
                    print(error)
                    switch error {
                    case .noInternetConnection:
                        self.loginViewDelegate?.noInternetConnectionWarning()
                    default:
                        self.loginViewDelegate?.unsuccessfulLogin()
                    }
                case .success(let value):
                    let defaults = UserDefaults.standard
                    defaults.set(value.token, forKey: "Token")
                    defaults.set(value.user_id, forKey: "UserId")
                    self.loginViewDelegate?.successfulLogin()
                }
            }
        }
    }
}
