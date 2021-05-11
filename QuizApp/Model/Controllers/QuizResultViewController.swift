//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 06.05.2021..
//

import UIKit

class QuizResultViewController: UIViewController {

    private var answers : [Bool]
    
    @IBOutlet weak var resultLabel: UILabel!
    
    init(answers : [Bool]) {
        self.answers = answers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = String(countTrue()) + "/" + String(answers.count)
        // Do any additional setup after loading the view.
    }

    func countTrue() -> Int {
        var count = 0
        for answer in answers {
            if answer == true {
                count = count + 1
            }
        }
        return count
    }
    @IBAction func finishQuizClicked(_ sender: UIButton) {
        let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
        sceneDelegate?.goToApp()
    }
}
