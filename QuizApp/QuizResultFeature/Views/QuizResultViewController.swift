//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 06.05.2021..
//

import UIKit

class QuizResultViewController: UIViewController, QuizResultViewDelegate {

    private var answers : [Bool]
    
    @IBOutlet weak var resultLabel: UILabel!
    
    private let quizResultPresenter = QuizResultPresenter()

    init(answers : [Bool]) {
        self.answers = answers
        quizResultPresenter.setAnswers(answers: answers)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quizResultPresenter.setViewDelegate(quizResultViewDelegate: self)

        resultLabel.text = String(quizResultPresenter.countTrue()) + "/" + String(answers.count)
    }

    
    @IBAction func finishQuizClicked(_ sender: UIButton) {
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        sceneDelegate?.goToApp()
    }
}
