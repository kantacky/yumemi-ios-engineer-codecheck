//
//  RepositoryViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kanta Oikawa on 2023/07/08.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

final class RepositoryViewModel {

    enum Input {
        case viewDidLoad(imageUrl: URL)
    }

    enum Output {
        case getImageFail(error: Error)
        case getImageSucceed(image: UIImage?)
    }

    private let repositoryModel: RepositoryModelProtocol
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    public init(repositoryModel: RepositoryModelProtocol = RepositoryModel()) {
        self.repositoryModel = repositoryModel
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case let .viewDidLoad(imageUrl):
                self?.handleGetImage(url: imageUrl)
            }
        }
        .store(in: &self.cancellables)

        return output.eraseToAnyPublisher()
    }

    func handleGetImage(url: URL) {
        repositoryModel.getImage(url: url).sink { completion in
            if case let .failure(error) = completion {
                self.output.send(.getImageFail(error: error))
            }
        } receiveValue: { [weak self] image in
            self?.output.send(.getImageSucceed(image: image))
        }
        .store(in: &self.cancellables)
    }
}
