//
//  StartQuizViewController.swift
//  QuizApp
//
//  Created by Pero Bokarica on 05.05.2021..
//

import UIKit

class StartQuizViewController: UIViewController {
    
    var quiz_ : Quiz
    
    @IBOutlet weak var quizName: UILabel!
    
    init(quiz : Quiz) {
        quiz_ = quiz
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //removes border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //sets the background color to the same as the rest of the screen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        
        let titleItem = UILabel()
        titleItem.text = "PopQuiz"
        titleItem.textColor = .white
        titleItem.font = titleItem.font.withSize(20)
        navigationItem.titleView = titleItem
        
        quizName.text = quiz_.title
    }

    @IBAction func startQuizButtonClicked(_ sender: UIButton) {
        //must add quiz_ as argument to controller
        let vc = PageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
