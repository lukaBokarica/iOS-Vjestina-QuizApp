//
//  PageViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 04.05.2021..
//

import UIKit

class PageViewController: UIPageViewController, PageViewDelegate  {
    
    private let pageViewPresenter = PageViewPresenter(networkService: NetworkService())
                
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewPresenter.setViewDelegate(pageViewDelegate: self)

        view.backgroundColor = .white
        let firstVC = pageViewPresenter.setUpControllers()
        setViewControllers([firstVC!], direction: .forward, animated: true, completion: nil)
        
        initialSetup()
        
        firstVC!.setUpQuestionTracker(answers: pageViewPresenter.getAnswers(), index: pageViewPresenter.getDisplayedIndex() + 1)
        
        pageViewPresenter.startMeasuringTime()
    }
    
    func initialSetup() {
        let titleItem = UILabel()
        titleItem.text = "PopQuiz"
        titleItem.textColor = .white
        titleItem.font = titleItem.font.withSize(20)
        navigationItem.titleView = titleItem
        
        let backArrow = UIImage(systemName: "chevron.backward")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backArrow, style: .done,
                                                           target: self, action: #selector(goBack))
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setPages(quizQuestionControllers : [QuizViewController]) {
        quizQuestionControllers.forEach({$0.delegate = self})
        pageViewPresenter.setPages(quizQuestionControllers: quizQuestionControllers)
    }
    
    func setQuiz(quiz : Quiz) {
        pageViewPresenter.setQuiz(quiz: quiz)
    }
    
    func toNextArticle() {
        let nextViewController = pageViewPresenter.getNextController()!
        
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: { completed in self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: completed) })
    }
    
    func goToResults() { 
        pageViewPresenter.handleEndOfQuiz()
        
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        sceneDelegate?.goToResults(answers: pageViewPresenter.getAnswers(), quiz: pageViewPresenter.getQuiz())
    }

}

extension PageViewController: QuizViewControllerDelegate {
    func nextClicked() {
        pageViewPresenter.handleNextClicked()
        
        pageViewPresenter.getControllers()[pageViewPresenter.getDisplayedIndex()].setUpQuestionTracker(answers: pageViewPresenter.getAnswers(), index: pageViewPresenter.getDisplayedIndex() + 1)
    }
    
    func answered(answer: Bool) {
        pageViewPresenter.handleAnswered(answer: answer)
    }
}

