//
//  LeaderboardPresenter.swift
//  QuizApp
//
//  Created by Pero Bokarica on 16.05.2021..
//

import UIKit

protocol LeaderboardDelegate: NSObjectProtocol, UITableViewDelegate, UITableViewDataSource {
    func completed()
}

class LeaderboardPresenter {

    private var networkService: NetworkServiceProtocol?
    
    weak private var leaderboardDelegate : LeaderboardDelegate?
    
    var quiz: Quiz?
    
    var results: [LeaderboardResult] = []
    
    init(networkService:NetworkService){
        self.networkService = networkService
    }
    
    func setViewDelegate(leaderboardDelegate:LeaderboardDelegate?){
        self.leaderboardDelegate = leaderboardDelegate
    }
    
    func setQuiz(quiz:Quiz) {
        self.quiz = quiz
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
        let doubleScore = Double(results[indexPath.row].score!)
        let intScore = Int(doubleScore!)
        let stringScore = String(intScore)
        cell.userScoreLabel.text = stringScore
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
        let usernameLabel = UILabel()
        let scoreLabel = UILabel()

        let headerView = UIView()
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headerView.addSubview(usernameLabel)
        headerView.addSubview(scoreLabel)

        usernameLabel.text = "Player"
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        usernameLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 5).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5).isActive = true
        usernameLabel.textAlignment = .right
        
        scoreLabel.text = "Score"
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        scoreLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -5).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5).isActive = true
        scoreLabel.textAlignment = .left
        
        headerView.backgroundColor = UIColor.systemIndigo

        return headerView
    }
    
    func getResults() {
        DispatchQueue.global().async {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "iosquiz.herokuapp.com"
            urlComponents.path = "/api/score"
            
            let queryItems = [URLQueryItem(name: "quiz_id", value: String(self.quiz!.id))]
            urlComponents.queryItems = queryItems
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let defaults = UserDefaults.standard
            request.setValue(defaults.string(forKey: "Token"), forHTTPHeaderField: "Authorization")
            
            self.networkService!.executeUrlRequest(request) { [weak self] (result: Result<[LeaderboardResult], RequestError>) in
                guard let self = self else { return }

                switch result {
                case .failure(let error):
                    print(error)
                case .success(var value):
                    value.removeAll(where: { $0.score == nil })
                    self.results = value
                    self.leaderboardDelegate?.completed()
                }
            }
        }
    }
}
