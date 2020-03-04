//
//  ErrorMessage.swift
//  RedditModRank
//
//  Created by Work on 03/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidModeratorName       = "This moderator name created an invalid request. Please try again."
    case invalidSubredditName       = "This subreddit name created an invalid request. Please try again."
    case unableToComplete           = "Unable to complete to complete your request. Please check your internet connection"
    case invalidResponse            = "Invalid response from the server. Please try again."
    case invalidData                = "The data received from the server was invalid. Please try again."
    case userDoesNotExist           = "Username does not exist anymore, might be banned or deleted"
    case noSubredditOrModerators    = "This subreddit does not seem to exist, or has no moderators!"
}
