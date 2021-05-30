//
//  QuizRepository.swift
//  QuizApp
//
//  Created by Luka Bokarica on 29.05.2021..
//

import UIKit
import Network

class QuizRepository: QuizRepositoryProtocol {

    let quizNetworkDataSource: QuizNetworkDataSource
    let quizDatabaseDataSource: QuizDatabaseDataSource
    let monitor = NWPathMonitor()
    var internetConnectionAvailable : Bool? = false
    
    init(databaseSource: QuizDatabaseDataSource, networkSource: QuizNetworkDataSource) {
        self.quizNetworkDataSource = networkSource
        self.quizDatabaseDataSource = databaseSource
        
        self.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.internetConnectionAvailable = true
            } else {
                self.internetConnectionAvailable = false
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func fetchRemoteData() -> [Quiz] {
        let quizzes = quizNetworkDataSource.fetchQuizzesFromAPI()
        quizDatabaseDataSource.deleteQuizzes()
        quizDatabaseDataSource.saveQuizzes(quizzes: quizzes)
        return quizzes
    }
    
    func fetchLocalData() -> [Quiz] {
        print("UZIMAM IZ CD!!!!")
        return quizDatabaseDataSource.fetchQuizzesFromCoreData()
    }
    
    func fetchData() -> [Quiz] {
        guard
            let internetConnectionAvailable = self.internetConnectionAvailable,
            internetConnectionAvailable
        else {
            return fetchLocalData()
        }
        return fetchRemoteData()
    }
}

