//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by Kanta Oikawa on 2023/07/09.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Repositories: Decodable {
    var items: [Repository]
}

struct Repository: Decodable {
    var fullname: String
    var language: String
    var stargazers_count: String
    var watchers_count: String
    var forks_count: String
    var open_issues_count: String
    var owner: Owner
}

struct Owner: Decodable {
    var avatar_url: String
}
