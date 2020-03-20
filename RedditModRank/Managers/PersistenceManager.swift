//
//  PersistenceManager.swift
//  RedditModRank
//
//  Created by Work on 19/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Subreddit, actionType: PersistenceActionType, completed: @escaping (ErrorMessage?) -> Void) {
        retrieveFavorites { result in
            switch result {
                case .success(let favorites):
                    var retrievedFavorites = favorites
                    switch actionType {
                    case .add:
                        let subNames = retrievedFavorites.map { $0.displayName }
                        guard !subNames.contains(favorite.displayName) else {
                            completed(.alreadyInFavorites)
                            return
                        }
                        retrievedFavorites.append(favorite)
                    case .remove:
                        retrievedFavorites.removeAll { $0.displayName == favorite.displayName }
                    }
                    completed(save(favorites: retrievedFavorites))
                case .failure(let error):
                    completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Subreddit], ErrorMessage>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Subreddit].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Subreddit]) -> ErrorMessage? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
