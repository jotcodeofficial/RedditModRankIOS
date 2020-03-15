//
//  Subreddit.swift
//  RedditModRank
//
//  Created by Work on 02/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation

private struct RawSubreddit: Decodable {
    var kind: String
    var data: Subreddit
}

struct SubredditResponse: Decodable {
    var subreddit: Subreddit

    init(from decoder: Decoder) throws {
        let rawResponse = try RawSubreddit(from: decoder)
        subreddit = rawResponse.data
    }
}

struct Subreddit: Codable, Hashable {
    var displayName: String
    var tite: String?
    var primaryColor: String?
    var subscribers: Int?
    var quarantine: Bool?
    var advertiserCategory: String?
    var publicDescription: String?
    var communityIcon: String?
    var iconImg: String?
    var createdUtc: Int?
    var over18: Bool?
    var description: String?
}
