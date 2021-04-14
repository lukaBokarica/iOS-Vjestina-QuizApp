//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 14.04.2021..
//

import UIKit

class QuizzesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ds : DataService
        ds = DataService()
        let quizzes = ds.fetchQuizes()
            
        for quiz in quizzes {
            print(quiz.id)
        }
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
