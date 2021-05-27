//
//  PageViewPresenter.swift
//  QuizApp
//
//  Created by Luka Bokarica on 13.05.2021..
//

import UIKit

protocol PageViewDelegate: NSObjectProtocol {
    func toNextArticle()
    func goToResults()
}

class PageViewPresenter {

    weak private var pageViewDelegate : PageViewDelegate?

    private var controllers : [QuizViewController]!
    
    private var displayedIndex = 0
    
    private var answers = [Bool]()
    
    private var startTime : DispatchTime?
    
    var networkService : NetworkServiceProtocol?
    
    var quiz : Quiz?
    
    init(networkService:NetworkService){
            self.networkService = networkService
    }
    
    func setViewDelegate(pageViewDelegate:PageViewDelegate?) {
        self.pageViewDelegate = pageViewDelegate
    }
    
    func getControllers() -> [QuizViewController] {
            return controllers
    }
    
    func getDisplayedIndex() -> Int {
        return displayedIndex
    }
    
    func getAnswers() -> [Bool] {
            return answers
    }
    
    func setPages(quizQuestionControllers : [QuizViewController]) {
        self.controllers = quizQuestionControllers
    }
    
    func setQuiz(quiz : Quiz) {
        self.quiz = quiz
    }
    
    func getQuiz() -> Quiz {
        return quiz!
    }
    
    func setUpControllers() -> QuizViewController? {
        guard let firstVC = controllers.first else { return nil }
        firstVC.setInfo(questionNumber: displayedIndex + 1, questionCount: controllers.count)
        return firstVC
    }
    
    func getNextController() -> UIViewController? {
        if(displayedIndex < controllers.count - 1) {
            displayedIndex = displayedIndex + 1
            controllers[displayedIndex].setInfo(questionNumber: displayedIndex + 1, questionCount: controllers.count)
            return controllers[displayedIndex]
        }
        return nil
    }
    
    func handleNextClicked() {
        if(displayedIndex < controllers.count - 1) {
            self.pageViewDelegate?.toNextArticle()
        } else {
            self.pageViewDelegate?.goToResults()
        }
    }
    
    func handleAnswered(answer: Bool) {
        answers.append(answer)
    }
    
    func handleEndOfQuiz() {
        let time = stopMeasuringTime(start: startTime!)
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "Token")!
        let userId = defaults.integer(forKey: "UserId")
        
        sendResults(time: time, token: token, userId: userId)
    }
    
    func sendResults(time: Double, token: String, userId: Int) {
        DispatchQueue.global().async {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "iosquiz.herokuapp.com"
            urlComponents.path = "/api/result"
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
            let defaults = UserDefaults.standard
            request.setValue(defaults.string(forKey: "Token"), forHTTPHeaderField: "Authorization")

            // prepare json data
            let json: [String: Any] = ["quiz_id": self.quiz!.id,
                                       "user_id": userId,
                                       "time": time,
                                       "no_of_correct": self.getNumberOfRights()]

            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            
            self.networkService!.executeUrlRequest(request) {(result: Result<ResultSendResponse, RequestError>) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(_):
                    print(time)
                    print("USPJEH")
                }
            }
        }
    }
    
    func getNumberOfRights() -> Int {
        var count = 0
        for answer in answers {
            if answer == true {
                count = count + 1
            }
        }
        return count
    }
    
    func startMeasuringTime() {
        startTime = DispatchTime.now() // <<<<<<<<<< Start time
    }
    
    func stopMeasuringTime(start : DispatchTime) -> Double {
        let end = DispatchTime.now()   // <<<<<<<<<<   end time

        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        return timeInterval
    }
}
