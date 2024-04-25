//
//  PostResource.swift
//  PostApp
//
//  Created by Sankaranarayana Settyvari on 25/04/24.
//

import Foundation
import Network

struct PostResource {
    
    func fetchPost(completionHandler: @escaping(_ result: [PostResponse]?)->()) {
        
        var urlRequest = URLRequest(url: URL(string: API.URL)!)
        urlRequest.addValue(API.acceptHeader, forHTTPHeaderField: "Accept")
        
        HttpUtility.shared.performDataTask(urlRequest: urlRequest, resultType: PostResponse.self) { result in
            _ = completionHandler(result)
        }
    }
}
