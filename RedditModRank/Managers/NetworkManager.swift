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
    
    func getModerators(for subreddit: String, completed: @escaping (Result<[Moderator], ErrorMessage>) -> Void) {
        let endpoint = baseURL + "/r/\(subreddit)/about/moderators.json"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidSubredditName))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(ErrorMessage.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(ErrorMessage.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(ModeratorResponse.self, from: data)
                let moderators = results.moderatorList
                completed(.success(moderators))
            } catch {
                completed(.failure(.invalidData))
                print(error.localizedDescription) //TODO
            }
            
        }
        
        task.resume()
    }
    
    func getUser(for username: String, completed: @escaping (Result<User, ErrorMessage>) -> Void) {

        let endpoint = baseURL + "/u/\(username)/about.json"
        
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
             
                   
                   guard let data = data else {
                    completed(.failure(.invalidData))
                       return
                   }
                   
                   do {
                    
                      let decoder = JSONDecoder()
                      decoder.keyDecodingStrategy = .convertFromSnakeCase
                      let result = try decoder.decode(UserResponse.self, from: data)
                    
                      let user = result.user
                   
                    completed(.success(user))
                  } catch {
                    completed(.failure(.invalidData))
                      print(error.localizedDescription) // TODO
                  }
                   
               }
               
               task.resume()
    }
    
    func getSubreddit() {
        
    }
}
