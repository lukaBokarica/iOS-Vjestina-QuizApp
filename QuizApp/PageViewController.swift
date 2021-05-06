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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setPages(quizQuestionControllers : [QuizViewController]) {
        quizQuestionControllers.forEach({$0.delegate = self})
        self.controllers = quizQuestionControllers
    }
    
    func toNextArticle(){
        let nextViewController = getNextController()!
        
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: { completed in self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: completed) })
    }
    
    func goToResults(){
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
