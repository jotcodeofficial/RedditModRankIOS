//
//  NetworkManager.swift
//  RedditModRank
//
//  Created by Work on 02/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared   = NetworkManager()
    let baseURL         = "https://reddit.com"
    
    // private so there can only be 1 instance ever
    private init() {
        
    }
    
    func getModerators(for subreddit: String, completed: @escaping ([Moderator]?, String?) -> Void) {
        let endpoint = baseURL + "/r/\(subreddit)/about/moderators.json"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "This subreddit created an invalid request. Please try again.")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(nil, "Unable to complete to complete your request. Please check your internet connection")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server. Please try again.")
                return
            }
            
            guard let data = data else {
                completed(nil, "The data received from the server was invalid. Please try again.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(ModeratorResponse.self, from: data)
                let moderators = results.moderatorList
                completed(moderators, nil)
            } catch {
                completed(nil, "The data received from the server was invalid. Please try again.")
            }
            
        }
        
        task.resume()
    }
    
    func getUser(username: String, completed: @escaping (User?, String) -> Void) {
        let endpoint = baseURL + "/user/\(username)/about.json"
    }
}
