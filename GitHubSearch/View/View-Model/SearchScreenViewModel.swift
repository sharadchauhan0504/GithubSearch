//
//  SearchScreenViewModel.swift
//  GitHubSearch
//
//  Created by Sharad S. Chauhan on 03/01/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import Foundation

class SearchScreenViewModel {
    
    private let networkOperation = NetworkOperations()
    
    var usernameSearchCallback: ((UserDetails) -> Void)?
    var userNameSearchFailure: (() -> Void)?
    
    func callUserSearchAPI(username: String) {
        networkOperation.hitGithubAPI(endPoint: "/\(username)")
        
        networkOperation.responseCallback = { [weak self] (responseData, isSuccess) in
            guard let weakSelf = self else {return}
            if isSuccess {
                do {
                    let response = try JSONDecoder().decode(UserDetails.self, from: responseData)
                    if let callBack = weakSelf.usernameSearchCallback {
                        callBack(response)
                    }
                } catch {
                    print("callUserSearchAPI error: \(error)")
                }
            } else {
                if let callBack = weakSelf.userNameSearchFailure {
                    callBack()
                }
            }
            
            
        }
    }
}
