//
//  RepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kanta Oikawa on 2023/07/09.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

protocol RepositoryModelProtocol {
    func getImage(url: URL) -> AnyPublisher<UIImage?, Error>
}

class RepositoryModel: RepositoryModelProtocol {

    func getImage(url: URL) -> AnyPublisher<UIImage?, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map({ UIImage(data: $0.data) })
            .eraseToAnyPublisher()
    }
}
