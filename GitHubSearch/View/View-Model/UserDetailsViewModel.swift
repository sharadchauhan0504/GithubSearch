//
//  UserDetailsViewModel.swift
//  GitHubSearch
//
//  Created by Sharad S. Chauhan on 04/01/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import Foundation

class UserDetailsViewModel {
    
    private let networkOperation = NetworkOperations()
    
    var repoSearchCallback: (([RepositoryDetails]) -> Void)?
    var repoSearchFailure: (() -> Void)?
    
    func callRepoSearchAPI(username: String) {
        networkOperation.hitGithubAPI(endPoint: "/\(username)/repos")
        
        networkOperation.responseCallback = { [weak self] (responseData, isSuccess) in
            guard let weakSelf = self else {return}
            if isSuccess {
                do {
                    let response = try JSONDecoder().decode([RepositoryDetails].self, from: responseData)
                    if let callBack = weakSelf.repoSearchCallback {
                        callBack(response)
                    }
                } catch {
                    print("callRepoSearchAPI error: \(error)")
                }
            } else {
                if let callBack = weakSelf.repoSearchFailure {
                    callBack()
                }
            }
            
            
        }
    }
}
