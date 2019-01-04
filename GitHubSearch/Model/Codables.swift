//
//  Codables.swift
//  GitHubSearch
//
//  Created by Sharad S. Chauhan on 03/01/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import Foundation

struct UserDetails: Codable {
    let name: String?
    let userName: String?
    let location: String?
    let company: String?
    let bio: String?
    
    let message: String?
    let avatarUrlString: String?
    let followersUrl: String?
    let reposUrl: String?
    let numberOfFollowers: Int?
    let numberOfFollowing: Int?
    let updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case userName          = "login"
        case location
        case company
        case bio
        case avatarUrlString   = "avatar_url"
        case followersUrl      = "followers_url"
        case reposUrl          = "repos_url"
        case numberOfFollowers = "followers"
        case numberOfFollowing = "following"
        case message           = "message"
        case updatedAt         = "updated_at"
    }
    
}

struct RepositoryDetails: Codable {
    let name: String?
    let language: String?
    let createdAt: String?
    let repoUrlString: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case language
        case createdAt     = "created_at"
        case repoUrlString = "html_url"
    }
}
