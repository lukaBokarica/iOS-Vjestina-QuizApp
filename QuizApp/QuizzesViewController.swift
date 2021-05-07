//
//  QuizzesViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 14.04.2021..
//

import UIKit

class QuizzesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var funFactLabel: UILabel!
    
    @IBOutlet weak var funFactTitleLabel: UILabel!
    
    @IBOutlet weak var lighbulbImage: UIImageView!
    
    @IBOutlet weak var quizTable: UITableView!
    
    var quizzesByCategory = Dictionary<QuizCategory,[Quiz]>()
        
    @IBAction func getQuizClicked(_ sender: UIButton) {
        let ds = DataService()
        let quizzes = ds.fetchQuizes()
        quizzesByCategory = Dictionary(grouping: quizzes) { (quiz) -> QuizCategory in
            return quiz.category
        }
        quizTable.reloadData()
        if(!quizzes.isEmpty) {
            quizTable.isHidden = false
            funFactLabel.isHidden = false
            lighbulbImage.isHidden = false
            funFactTitleLabel.isHidden = false
        } else {
            //add error sign and label
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizTable.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        quizTable.delegate = self
        quizTable.dataSource = self
        quizTable.backgroundColor = .clear
        quizTable.isHidden = true
        let ds = DataService()
        let quizzes = ds.fetchQuizes()
        quizzesByCategory = Dictionary(grouping: quizzes) { (quiz) -> QuizCategory in
            return quiz.category
        }
        
        let funFactNum = getFunFact(quizzes: quizzes)
        funFactLabel.text = "There are " + String(funFactNum) +
            " quizzes that contain the word NBA."
        funFactLabel.isHidden = true
        lighbulbImage.isHidden = true
        funFactTitleLabel.isHidden = true
        getCategories(quizzes: quizzes)
        
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
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizzesByCategory.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let quizCat = Array(quizzesByCategory.keys)[section]
        return quizzesByCategory[quizCat]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCell.identifier,
            for: indexPath) as! TableViewCell
        let quizCat = Array(quizzesByCategory.keys)[indexPath.section]
        cell.quizNameLabel.text = quizzesByCategory[quizCat]![indexPath.row].title
        cell.quizDescriptionLabel.text = quizzesByCategory[quizCat]![indexPath.row].description
        cell.quizDifficultyLabel!.text! = "Difficulty: " + String(quizzesByCategory[quizCat]![indexPath.row].level)
        cell.selectionStyle = .none
        return cell
    }
    
    //func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      //  let quizCat = Array(quizzesByCategory.keys)[section]
       // let categoryName = quizCat.rawValue
        //return categoryName
    //}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let quizCat = Array(quizzesByCategory.keys)[section]
        let categoryName = quizCat.rawValue
        
        let headerView = UILabel()
        headerView.text = "    " + categoryName
        headerView.backgroundColor = UIColor.systemIndigo
        headerView.textColor = .white
        headerView.font = UIFont.boldSystemFont(ofSize: 20)
        //quizTable.tableHeaderView = headerView
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let quizCat = Array(quizzesByCategory.keys)[indexPath.section]
        let quiz = quizzesByCategory[quizCat]![indexPath.row]
        let vc = StartQuizViewController(quiz: quiz)
        self.navigationController?.pushViewController(vc, animated: true)
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
}
