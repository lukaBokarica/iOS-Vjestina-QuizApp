//
//  StartQuizPresenter.swift
//  QuizApp
//
//  Created by Luka Bokarica on 13.05.2021..
//

import UIKit

protocol StartQuizViewDelegate: NSObjectProtocol {
    
}

class StartQuizPresenter {
    
    weak private var startQuizViewDelegate : StartQuizViewDelegate?

    var quiz : Quiz?

    func setViewDelegate(startQuizViewDelegate:StartQuizViewDelegate?) {
        self.startQuizViewDelegate = startQuizViewDelegate
    }
    
    func setQuiz(quiz: Quiz) {
        self.quiz = quiz
    }
    
    func getQuiz() -> Quiz {
        return quiz!
    }
    
    func executeQuizStarting() -> UIViewController? {
        let vc = PageViewController()
        let questions = quiz!.questions
        var quizViewControllers : [QuizViewController] = []
        for question in questions {
            quizViewControllers.append(QuizViewController(question: question))
        }
        vc.setPages(quizQuestionControllers: quizViewControllers)
        vc.setQuiz(quiz: quiz!)
        return vc
    }
}
