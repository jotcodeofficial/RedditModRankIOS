//
//  Subreddit.swift
//  RedditModRank
//
//  Created by Work on 02/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation

struct Subreddit: Codable {
    var displayName: String
    var tite: String
    var primaryColor: String
    var subscribers: Int
    var quarantine: Bool
    var advertiserCategory: String
    var publicDescription: String
    var communityIcon: String
    var created: Int
    var over18: Bool
    var description: String
    
}
