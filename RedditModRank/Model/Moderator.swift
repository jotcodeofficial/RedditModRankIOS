//
//  Moderator.swift
//  RedditModRank
//
//  Created by Work on 02/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation

private struct RawModerator: Decodable {
    struct Data: Decodable {
        var children: [Moderator]
    }

    var kind: String
    var data: Data
}

struct ModeratorResponse: Decodable {
    var moderatorList: [Moderator]

    init(from decoder: Decoder) throws {
        let rawResponse = try RawModerator(from: decoder)
        moderatorList = rawResponse.data.children
    }
}

struct Moderator: Codable {
    var name: String
}
