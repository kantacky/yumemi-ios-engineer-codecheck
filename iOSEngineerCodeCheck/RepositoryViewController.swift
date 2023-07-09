//
//  RepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

class RepositoryViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!

    private let viewModel: RepositoryViewModel = .init()
    private let input: PassthroughSubject<RepositoryViewModel.Input, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()

    var searchBarViewController: SearchBarViewController!

    override func viewDidLoad() {
        let repository = searchBarViewController.repositories[searchBarViewController.index]

        super.viewDidLoad()
        self.bind()

        if let owner = repository["owner"] as? [String: Any],
           let imageUrl = owner["avatar_url"] as? String,
           let url = URL(string: imageUrl) {
            input.send(.viewDidLoad(imageUrl: url))
        }

        self.titleLabel.text = repository["full_name"] as? String
        self.languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        self.starsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        self.watchersLabel.text = "\(repository["watchers_count"] as? Int ?? 0) watchers"
        self.forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        self.issuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
    }

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
            case let .getImageSucceed(image):
                self?.imageView.image = image
            case let .getImageFail(error):
                self?.imageView.image = nil
                print(error.localizedDescription)
            }
        }
        .store(in: &self.subscriptions)
    }
}
