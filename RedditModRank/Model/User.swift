//
//  User.swift
//  RedditModRank
//
//  Created by Work on 02/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String
    var iconImg: String
    var hasVerifiedEmail: Bool
}
