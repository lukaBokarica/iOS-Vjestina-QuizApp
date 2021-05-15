//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by Luka Bokarica on 14.05.2021..
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var leaderboardTable: UITableView!
    
    var leaderboardResults: [LeaderboardResult] = []
    
    var networkService: NetworkServiceProtocol?
    
    var quiz: Quiz?
    
    var results: [LeaderboardResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()

        networkService = NetworkService()

        DispatchQueue.main.async {
            self.getResults()
        }

                
    }

    func initialSetup() {
        leaderboardTable.register(LeaderBoardCellView.nib(), forCellReuseIdentifier: LeaderBoardCellView.identifier)
        leaderboardTable.delegate = self
        leaderboardTable.dataSource = self
        leaderboardTable.backgroundColor = .clear
        
        //removes border from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //sets the background color to the same as the rest of the screen
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .systemIndigo
        
        self.navigationController?.navigationBar.tintColor = .white
        
        let titleItem = UILabel()
        titleItem.text = "Leaderboard"
        titleItem.textColor = .white
        titleItem.font = titleItem.font.withSize(25)
        navigationItem.titleView = titleItem
        
        let xSign = UIImage(systemName: "xmark")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: xSign, style: .done,
                                                           target: self, action: #selector(goBack))
        
    }
    
    func setQuiz(quiz: Quiz) {
        self.quiz = quiz
    }
    
    @objc func goBack() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeaderBoardCellView = tableView.dequeueReusableCell(
            withIdentifier: LeaderBoardCellView.identifier,
            for: indexPath) as! LeaderBoardCellView
        
        cell.userRankLabel.text = String(indexPath.row + 1)
        cell.usernameLabel.text = results[indexPath.row].username
        cell.userScoreLabel.text = results[indexPath.row].score!
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //dodati custom view po slici s figme
        let headerView = UILabel()
        headerView.text = "   Player" + "                                                " + "Score"
        headerView.backgroundColor = UIColor.systemIndigo
        headerView.textColor = .white
        headerView.font = UIFont.boldSystemFont(ofSize: 20)
        
        return headerView
    }
    
    func getResults() {
        DispatchQueue.global().async {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "iosquiz.herokuapp.com"
            urlComponents.path = "/api/score"
            
            //provjeriti liniju ispod
            let queryItems = [URLQueryItem(name: "quiz_id", value: String(self.quiz!.id))]
            urlComponents.queryItems = queryItems
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let defaults = UserDefaults.standard
            request.setValue(defaults.string(forKey: "Token"), forHTTPHeaderField: "Authorization")
            
            self.networkService!.executeUrlRequest(request) {(result: Result<[LeaderboardResult], RequestError>) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    print("success")
                    self.completed(leaderboardResults: value)
                }
            }
        }
    }
    
    func completed(leaderboardResults: [LeaderboardResult]) {
        results = leaderboardResults
        leaderboardTable.reloadData()
    }
}
