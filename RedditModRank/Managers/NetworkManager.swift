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
    
    func getModerators(for subreddit: String, completed: @escaping ([Moderator]?, ErrorMessage?) -> Void) {
        let endpoint = baseURL + "/r/\(subreddit)/about/moderators.json"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .invalidSubredditName)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(nil, .unableToComplete)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .invalidResponse)
                return
            }
            
            guard let data = data else {
                completed(nil, .invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(ModeratorResponse.self, from: data)
                let moderators = results.moderatorList
                completed(moderators, nil)
            } catch {
                completed(nil, .invalidData)
                print(error.localizedDescription) //TODO
            }
            
        }
        
        task.resume()
    }
    
    func getUser(for username: String, completed: @escaping (User?, ErrorMessage?) -> Void) {

        let endpoint = baseURL + "/u/\(username)/about.json"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .invalidModeratorName)
                   return
               }
               let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                print("url: \(endpoint)")

                print("username \(username)")
                print("data \(data)")
                   if let _ = error {
                    print("unable 2 compleet")
                    completed(nil, .unableToComplete)
                       return
                   }
                
                
                
                    guard let response = response as? HTTPURLResponse else {
                        print("invalid response")
                        completed(nil, .invalidResponse)
                       return
                   }
                
            
                    if(response.statusCode == 404) {
                        print("404")
                        completed(nil, .userDoesNotExist)
                        return
                    }
             
                   
                   guard let data = data else {
                    completed(nil, .invalidData)
                       return
                   }
                   
                   do {
                    
                      let decoder = JSONDecoder()
                      decoder.keyDecodingStrategy = .convertFromSnakeCase
                      let result = try decoder.decode(UserResponse.self, from: data)
                    
                      let user = result.user
                   
                      completed(user, nil)
                  } catch {
                      completed(nil, .invalidData)
                      print(error.localizedDescription) //TODO
                  }
                   
               }
               
               task.resume()
    }
    
    func getSubreddit() {
        
    }
}
