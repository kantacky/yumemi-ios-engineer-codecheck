//
//  SearchModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kanta Oikawa on 2023/07/09.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

protocol SearchModelProtocol {
    func getRepositories(url: URL) -> AnyPublisher<Repositories, Error>
}

class SearchModel: SearchModelProtocol {

    func getRepositories(url: URL) -> AnyPublisher<Repositories, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map({ $0.data })
            .decode(type: Repositories.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
