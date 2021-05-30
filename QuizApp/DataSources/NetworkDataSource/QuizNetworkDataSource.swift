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
    weak private var quizzesViewDelegate : QuizzesViewDelegate?

    init(networkService: NetworkService) {
        self.networkService = networkService
        quizzes = []
    }
    
    func setQuizzesViewDelegate(delegate: QuizzesViewDelegate) {
        self.quizzesViewDelegate = delegate
    }
    
    func fetchQuizzesFromAPI(quizDatabaseDataSource: QuizDatabaseDataSource) -> [Quiz] {
        
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
                    self.quizzesViewDelegate?.completed(quizzes: value.quizzes)
                    quizDatabaseDataSource.saveQuizzes(quizzes: value.quizzes)
                    //self.quizzes = value.quizzes
                }
            }
        }
        //VRATI PRAZNOOOOOOOOOO
        print("Broj kvizova: " + String(quizzes.count))
        return quizzes
    }
}
