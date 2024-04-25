//
//  PostResponse.swift
//  PostApp
//
//  Created by Sankaranarayana Settyvari on 25/04/24.
//

import Foundation

struct PostResponse: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
