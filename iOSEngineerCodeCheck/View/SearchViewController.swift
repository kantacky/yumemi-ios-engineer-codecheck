//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

final class SearchViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    private let viewModel: SearchViewModel = .init()
    private let input: PassthroughSubject<SearchViewModel.Input, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()

    var repositories: [Repository] = []
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()

        input.send(.viewDidLoad)

        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
    }

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
            switch event {
            case let .getRepositoriesSucceed(repositories):
                self?.repositories = repositories
                self?.tableView.reloadData()
            case let .getRepositoriesFail(error):
                self?.repositories = []
                self?.tableView.reloadData()
                print(error.localizedDescription)
            case let .changeQueryText(newText):
                self?.searchBar.text = newText
            }
        }
        .store(in: &self.subscriptions)
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        input.send(.onTappedSearchBar)
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        input.send(.onChangedText(newText: searchText))

        if searchText.count == 0 {
            self.repositories = []
            self.tableView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        input.send(.onTappedSearchButton)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail",
           let dtl = segue.destination as? RepositoryViewController {
            dtl.searchBarViewController = self
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.full_name
        cell.detailTextLabel?.text = repository.language
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // On the screen transition
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
