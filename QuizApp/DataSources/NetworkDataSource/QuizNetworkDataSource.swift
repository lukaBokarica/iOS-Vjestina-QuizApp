//
//  QuizNetworkDataSource.swift
//  QuizApp
//
//  Created by Luka Bokarica on 29.05.2021..
//

import UIKit

class QuizNetworkDataSource {
    
    let networkService: NetworkService
    var quizzes: [Quiz]
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        quizzes = []
    }
    
    func fetchQuizzesFromAPI() -> [Quiz] {
        DispatchQueue.global().async {
            guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
            self.networkService.executeUrlRequest(request) { [weak self] (result: Result<QuizzesResponse, RequestError>) in
                guard let self = self else { return }

                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    print(value)
                    self.quizzes = value.quizzes
                }
            }
        }
        print("Broj kvizova: " + String(quizzes.count))
        return quizzes
    }
}
