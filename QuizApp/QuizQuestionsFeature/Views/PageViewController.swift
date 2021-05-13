//
//  PageViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 04.05.2021..
//

import UIKit

class PageViewController: UIPageViewController  {
    
    private var controllers : [QuizViewController]!
    
    private var displayedIndex = 0
    
    private var answers = [Bool]()
    
    private var startTime : DispatchTime?
    
    var networkService : NetworkServiceProtocol?
    
    var quiz : Quiz?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService = NetworkService()

        view.backgroundColor = .white
        guard let firstVC = controllers.first else { return }
        firstVC.setInfo(questionNumber: displayedIndex + 1, questionCount: controllers.count)
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        
        let titleItem = UILabel()
        titleItem.text = "PopQuiz"
        titleItem.textColor = .white
        titleItem.font = titleItem.font.withSize(20)
        navigationItem.titleView = titleItem
        
        let backArrow = UIImage(systemName: "chevron.backward")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backArrow, style: .done,
                                                           target: self, action: #selector(goBack))
        
        firstVC.setUpQuestionTracker(answers: answers, index: displayedIndex + 1)
        
        startTime = startMeasuringTime()
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setPages(quizQuestionControllers : [QuizViewController]) {
        quizQuestionControllers.forEach({$0.delegate = self})
        self.controllers = quizQuestionControllers
    }
    
    func setQuiz(quiz : Quiz) {
        self.quiz = quiz
    }
    
    func toNextArticle(){
        let nextViewController = getNextController()!
        
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: { completed in self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: completed) })
    }
    
    func goToResults(){
        let time = stopMeasuringTime(start: startTime!)
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "Token")!
        let userId = defaults.integer(forKey: "UserId")
        
        sendResults(time: time, token: token, userId: userId)
        
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        sceneDelegate?.goToResults(answers: answers)
    }
    
    func getNextController() -> UIViewController? {
        if(displayedIndex < controllers.count - 1) {
            displayedIndex = displayedIndex + 1
            controllers[displayedIndex].setInfo(questionNumber: displayedIndex + 1, questionCount: controllers.count)
            return controllers[displayedIndex]
        }
        return nil
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

}

extension PageViewController: QuizViewControllerDelegate {
    func nextClicked() {
        
        if(displayedIndex < controllers.count - 1) {
            toNextArticle()
        } else {
            goToResults()
        }
        
        controllers[displayedIndex].setUpQuestionTracker(answers: answers, index: displayedIndex + 1)
    }
    
    func answered(answer: Bool) {
        answers.append(answer)
    }
}

extension PageViewController {
    
    func startMeasuringTime() -> DispatchTime {
        let start = DispatchTime.now() // <<<<<<<<<< Start time
        return start
    }
    
    func stopMeasuringTime(start : DispatchTime) -> Double {
        let end = DispatchTime.now()   // <<<<<<<<<<   end time

        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        return timeInterval
    }
}
