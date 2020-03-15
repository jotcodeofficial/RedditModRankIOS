//
//  NetworkManager.swift
//  RedditModRank
//
//  Created by Work on 02/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared   = NetworkManager()
    let baseURL         = "https://reddit.com"
    let subredditOption         = "/r/"
    let userOption              = "/user/"
    let endSubModeratorsOption  = "/about/moderators"
    let cache           = NSCache<NSString, UIImage>()
    
    // private so there can only be 1 instance ever
    private init() {
        
    }
    
    
    
    
    func getUser(for username: String, completed: @escaping (Result<User, ErrorMessage>) -> Void) {
        
        let endpoint = baseURL + "/user/\(username)/about.json"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidModeratorName))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            
            
            guard let response = response as? HTTPURLResponse else {
                completed(.failure(.invalidResponse))
                return
            }
            
            
            if(response.statusCode == 404) {
                completed(.failure(.userDoesNotExist))
                return
            }
            
            if(response.statusCode == 403) {
                completed(.failure(.userHasBeenSuspended))
                return
            }
            
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(UserResponse.self, from: data)
                
                var user = result.user
                
                if let isSuspended = user.isSuspended {
                    if isSuspended {
                        completed(.failure(.userHasBeenSuspended))
                        return
                    }
                }
                
                // alter the users avatar image if it has styling
                if user.iconImg!.contains("?") {
                    
                    if let indexEndOfPattern = user.iconImg!.range(of: "?") {
                        let newImageURL = String(user.iconImg![..<indexEndOfPattern.lowerBound])
                        user.iconImg = newImageURL
                    }
                }
                
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
                print(error.localizedDescription) // TODO
            }
            
        }
        
        task.resume()
    }
    
    
    func getSubreddit(for subreddit: String, completed: @escaping (Result<Subreddit, ErrorMessage>) -> Void) {
        
        let endpoint = baseURL + "/r/\(subreddit)/about.json"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidSubredditName))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            
            
            guard let response = response as? HTTPURLResponse else {
                completed(.failure(.invalidResponse))
                return
            }
            
            
            if(response.statusCode == 404) {
                completed(.failure(.subredditDoesNotExist))
                return
            }
            
            if(response.statusCode == 403) {
                completed(.failure(.subredditIsPrivate))
                return
            }
            
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
    
                let result = try decoder.decode(SubredditResponse.self, from: data)

                var subreddit = result.subreddit
                
                // alter the users avatar image if it has styling
                if subreddit.communityIcon!.contains("?") {
                    
                    if let indexEndOfPattern = subreddit.communityIcon!.range(of: "?") {
                        let newImageURL = String(subreddit.communityIcon![..<indexEndOfPattern.lowerBound])
                        subreddit.communityIcon = newImageURL
                    }
                }
                
                completed(.success(subreddit))
            } catch {
                completed(.failure(.invalidData))
                print(error.localizedDescription) // TODO
            }
            
        }
        
        task.resume()
    }
    
}
