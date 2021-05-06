//
//  PageViewController.swift
//  QuizApp
//
//  Created by Pero Bokarica on 04.05.2021..
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource  {
    
    private var controllers : [QuizViewController]!
    
    private var displayedIndex = 0
    
    private var answers = [Bool]()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if(displayedIndex < controllers.count - 1) {
            displayedIndex = displayedIndex + 1
            controllers[displayedIndex].setInfo(questionNumber: displayedIndex + 1, questionCount: controllers.count)
            return controllers[displayedIndex]
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard let firstVC = controllers.first else { return }
        firstVC.setInfo(questionNumber: displayedIndex + 1, questionCount: controllers.count)
        dataSource = self
        setViewControllers([firstVC], direction: .forward, animated: true,
        completion: nil)
        
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
        self.controllers = quizQuestionControllers
    }
    
    func toNextArticle(){
        guard let currentViewController = self.viewControllers?.first else { return }

        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController ) else { return }

        // Has to be set like this, since else the delgates for the buttons won't work
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: { completed in self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: completed) })
    }
    
    func goToResults(){
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        sceneDelegate?.goToResults(answers: answers)
    }
    
}

extension PageViewController: QuizViewControllerDelegate {
    func nextClicked() {
        if(displayedIndex < controllers.count - 1) {
            toNextArticle()
        } else {
            goToResults()
        }
    }
    
    func answered(answer: Bool) {
        answers.append(answer)
    }
}
