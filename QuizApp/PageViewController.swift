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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if(displayedIndex < controllers.count - 1) {
            displayedIndex = displayedIndex + 1
            return QuizViewController(question: controllers[displayedIndex].getQuestion())
        }
        //fix this return!!!! goes to quiz result page
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard let firstVC = controllers.first else { return }
        //postavljanje boje indikatora stranice
        dataSource = self
        setViewControllers([firstVC], direction: .forward, animated: true,
        completion: nil)
        
        let backArrow = UIImage(systemName: "chevron.backward")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backArrow, style: .done,
                                                           target: self, action: #selector(goBack))
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setPages(quizQuestionControllers : [QuizViewController]) {
        self.controllers = quizQuestionControllers
    }
}
