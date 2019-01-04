//
//  NetworkOperations.swift
//  GitHubSearch
//
//  Created by Sharad S. Chauhan on 03/01/19.
//  Copyright © 2019 Sharad S. Chauhan. All rights reserved.
//

import Foundation

class NetworkOperations {
    
    let urlSession = URLSession(configuration: .default)
    
    var responseCallback: ((Data, Bool) -> Void)?
    
    func hitGithubAPI(endPoint: String) {
        let urlString = baseUrl + endPoint
        guard let url = URL(string: urlString) else {return}
        
        let dataTask = urlSession.dataTask(with: url) { (responseData, response, error) in
            if error != nil, let callback = self.responseCallback {
                callback(Data(), false)
            } else if let data = responseData, let callback = self.responseCallback {
                callback(data, true)
            }
        }
        
        dataTask.resume()
    }
}
