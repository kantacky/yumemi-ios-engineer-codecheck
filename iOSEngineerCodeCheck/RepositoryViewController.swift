//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LanguageLabel: UILabel!
    @IBOutlet weak var StarsLabel: UILabel!
    @IBOutlet weak var WatchersLabel: UILabel!
    @IBOutlet weak var ForksLabel: UILabel!
    @IBOutlet weak var IssuesLabel: UILabel!

    var searchBarViewController: SearchBarViewController!
    var task: URLSessionTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        let repo = searchBarViewController.repositories[searchBarViewController.index]

        LanguageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        StarsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        WatchersLabel.text = "\(repo["watchers_count"] as? Int ?? 0) watchers"
        ForksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        IssuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
    }
    
    func getImage() {
        let repo = searchBarViewController.repositories[searchBarViewController.index]

        TitleLabel.text = repo["full_name"] as? String

        if let owner = repo["owner"] as? [String: Any],
           let imgURL = owner["avatar_url"] as? String {
            task = URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
                let img = UIImage(data: data!)!
                DispatchQueue.main.async {
                    self.ImageView.image = img
                }
            }

            task?.resume()
        }
    }
}
