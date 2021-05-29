//
//  QuizzesPresenter.swift
//  QuizApp
//
//  Created by Luka Bokarica on 13.05.2021..
//

import UIKit

protocol QuizzesViewDelegate: NSObjectProtocol {
    func completed(quizzes: [Quiz])
    func showErrorLabel()
    func pushStartQuiz(startQuizController: StartQuizViewController)
}

class QuizzesPresenter: NSObject, UITableViewDataSource {
    
    private let networkService: NetworkServiceProtocol
    
    weak private var quizzesViewDelegate : QuizzesViewDelegate?
    
    var quizzesByCategory = Dictionary<QuizCategory,[Quiz]>()

    var quizzes : [Quiz] = []

    let quizzesRepository: QuizRepository
    
    init(networkService:NetworkService){
        self.networkService = networkService
        let coreDataContext = CoreDataStack(modelName: "quizAppCD").managedContext
        self.quizzesRepository = QuizRepository.init(databaseSource: QuizDatabaseDataSource(coreDataContext: coreDataContext), networkSource: QuizNetworkDataSource(networkService: self.networkService as! NetworkService))
    }
    
    func setViewDelegate(quizzesViewDelegate:QuizzesViewDelegate?){
        self.quizzesViewDelegate = quizzesViewDelegate
    }
    
    func fetchQuizzes() {
        self.quizzesViewDelegate?.completed(quizzes: quizzesRepository.fetchData())
//        DispatchQueue.global().async {
//            guard let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes") else { return }
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            self.networkService.executeUrlRequest(request) { [weak self] (result: Result<QuizzesResponse, RequestError>) in
//                guard let self = self else { return }
//
//                switch result {
//                case .failure(_):
//                    self.quizzesViewDelegate?.showErrorLabel()
//                case .success(let value):
//                    self.quizzesViewDelegate?.completed(quizzes: value.quizzes)
//                }
//            }
//        }
    }
    
    func getFunFact(quizzes : [Quiz]) -> Int {
        var stringAppearanceCounter = 0
        for quiz in quizzes {
            let quizQuestions = quiz.questions
            for question in quizQuestions {
                if(question.question.contains("NBA")) {
                    stringAppearanceCounter += 1
                }
            }
        }
        return stringAppearanceCounter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizzesByCategory.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let quizCat = Array(quizzesByCategory.keys)[section]
        return quizzesByCategory[quizCat]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCell.identifier,
            for: indexPath) as! TableViewCell
        let quizCat = Array(quizzesByCategory.keys)[indexPath.section]
        cell.quizNameLabel.text = quizzesByCategory[quizCat]![indexPath.row].title
        cell.quizDescriptionLabel.text = quizzesByCategory[quizCat]![indexPath.row].description
        cell.quizDifficultyLabel!.text! = "Difficulty: " + String(quizzesByCategory[quizCat]![indexPath.row].level)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let quizCat = Array(quizzesByCategory.keys)[section]
        let categoryName = quizCat.rawValue
        
        let headerView = UILabel()
        headerView.text = "    " + categoryName
        headerView.backgroundColor = UIColor.systemIndigo
        headerView.textColor = .white
        headerView.font = UIFont.boldSystemFont(ofSize: 22)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let quizCat = Array(quizzesByCategory.keys)[indexPath.section]
        let quiz = quizzesByCategory[quizCat]![indexPath.row]
        let vc = StartQuizViewController()
        vc.setQuiz(quiz: quiz)
        self.quizzesViewDelegate?.pushStartQuiz(startQuizController: vc)
    }
    
    func setQuizzes(quizzes: [Quiz]) {
        self.quizzes = quizzes
        self.quizzesByCategory = Dictionary(grouping: quizzes) { (quiz) -> QuizCategory in
            return quiz.category
        }
    }
    
}
