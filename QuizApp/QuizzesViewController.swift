//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 14.04.2021..
//

import UIKit

class QuizzesViewController: UIViewController {
    
    @IBOutlet weak var funFactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ds = DataService()
        let quizzes = ds.fetchQuizes()
        
        let funFactNum = getFunFact(quizzes: quizzes)
        funFactLabel.text = "There are " + String(funFactNum) +
            " quizzes that contain the word NBA."
        getCategories(quizzes: quizzes)
    }
    
    func getCategories(quizzes : [Quiz]) {
        var categories = Set<QuizCategory>()
        
        for quiz in quizzes {
            categories.insert(quiz.category)
        }
    }
    
    func getFunFact(quizzes : [Quiz]) -> Int {
        var stringAppearanceCounter = 0
        for quiz in quizzes {
            let quizQuestions = quiz.questions
            for question in quizQuestions {
                if(question.question.contains("NBA")) {
                    stringAppearanceCounter += 1
                }
            }
        }
        return stringAppearanceCounter
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
