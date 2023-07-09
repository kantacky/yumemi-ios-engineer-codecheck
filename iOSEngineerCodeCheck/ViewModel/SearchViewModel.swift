//
//  SearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kanta Oikawa on 2023/07/09.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

final class SearchViewModel {

    enum Input {
        case viewDidLoad
        case onTappedSearchBar
        case onChangedText(newText: String)
        case onTappedSearchButton
    }

    enum Output {
        case getRepositoriesFail(error: Error)
        case getRepositoriesSucceed(repositories: [Repository])
        case changeQueryText(newText: String)
    }

    private let model: SearchModelProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()

    private var queryText: String = ""

    public init(model: SearchModelProtocol = SearchModel()) {
        self.model = model
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.handleChangeText(newText: "GitHubのリポジトリを検索できるよー")
            case .onTappedSearchBar:
                self?.handleChangeText(newText: "")
            case let .onChangedText(newText):
                self?.handleChangeText(newText: newText)
            case .onTappedSearchButton:
                self?.handleGetRepositories()
            }
        }
        .store(in: &self.cancellables)

        return output.eraseToAnyPublisher()
    }

    func handleChangeText(newText: String) {
        self.queryText = newText
        self.output.send(.changeQueryText(newText: self.queryText))
    }

    func handleGetRepositories() {
        if self.queryText.count > 0,
           let url = URL(string: "https://api.github.com/search/repositories?q=\(self.queryText)") {
            model.getRepositories(url: url).sink { completion in
                if case let .failure(error) = completion {
                    self.output.send(.getRepositoriesFail(error: error))
                }
            } receiveValue: { [weak self] repositories in
                self?.output.send(.getRepositoriesSucceed(repositories: repositories))
            }
            .store(in: &self.cancellables)
        }
    }
}
