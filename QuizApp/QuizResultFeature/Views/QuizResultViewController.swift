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

        initialSetup()
    }
    
    func setQuiz(quiz: Quiz) {
        quizResultPresenter.setQuiz(quiz: quiz)
    }
    
    func initialSetup() {
        resultLabel.text = String(quizResultPresenter.countTrue()) + "/" + String(answers.count)
        //removes border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //sets the background color to the same as the rest of the screen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
    }

    
    @IBAction func seeLeaderboardClicked(_ sender: UIButton) {
        let vc = LeaderboardViewController()
        vc.setQuiz(quiz: quizResultPresenter.getQuiz()!)
        let nvc = UINavigationController()
        nvc.viewControllers = [vc]
        self.navigationController?.present(nvc, animated: true, completion: nil)
    }
    
    @IBAction func finishQuizClicked(_ sender: UIButton) {
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        sceneDelegate?.goToApp()
    }
}
