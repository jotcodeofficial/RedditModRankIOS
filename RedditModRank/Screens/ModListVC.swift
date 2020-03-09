//
//  ModListVC.swift
//  RedditModRank
//
//  Created by Work on 28/02/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class ModListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var subreddit: String!
    var simpleModerators: [Moderator] = []
    var finalModerators: [User] = []
    var filteredModerators: [User] = []
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, User>!
    var isSearching: Bool = false
    
    private let baseURL                 = "https://reddit.com"
    private let subredditOption         = "/r/"
    private let userOption              = "/user/"
    private let endSubModeratorsOption  = "/about/moderators"
    private var firstIterationGetModerators = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getModerators(url: URL(string: baseURL + subredditOption + subreddit + endSubModeratorsOption)!)
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ModeratorCell.self, forCellWithReuseIdentifier: ModeratorCell.resuseID)
    }
    
    
    func getModerators(url: URL) {
        
        // Start the network call
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // No Data from call
            guard let data = data, error == nil else {
                print("data was nil")
                return
            }
            
            // Issue with getting data into a string
            guard var htmlString = String(data: data, encoding: .utf8) else {
                print("Retrieved data cannot cast data into string")
                return
            }
            
            // Get a count of all the user elements on the page
            let counter =  htmlString.components(separatedBy:"href=\"/user/")
            let count = counter.count-1
            
            
            if (count <= 0 && self.firstIterationGetModerators) {
                self.presentMRAlertOnMainThread(title: "Whoops", message: ErrorMessage.noSubredditOrModerators.rawValue, buttonTitle: "Ok")
                self.firstIterationGetModerators = false
                return
            }
            
            // Get the next page URL if it exists on this page
            // We do this here because we are removing the start part of html on each increment for usernames
            // If it exists but does not have the ?after then this is the last page
            // If last page set flag so we do not trigger another network call for more pages
            let leftSideOfNextPageURLValue = "/about/moderators?after="
            let rightSideOfNextPageURLValue = "\"><svg"
            
            var newUrl: URL?
            var isThereANextPage = false
            if let newUrlId = htmlString.slice(from: leftSideOfNextPageURLValue, to: rightSideOfNextPageURLValue) {
                isThereANextPage = true
                print(self.baseURL + self.subredditOption + self.subreddit + leftSideOfNextPageURLValue + newUrlId)
                newUrl = URL(string: self.baseURL + self.subredditOption + self.subreddit + leftSideOfNextPageURLValue + newUrlId)
            }
            
            // Starting the loop to collect all the usernames
            for  _ in 1...count {
                
                let leftSideOfUsernameValue = "href=\"/user/"
                let rightSideOfUsernameValue = "\""
                
                let leftSideOfAvatarURLValue = "><img src=\""
                let rightSideOfAvatarURLValue = "\""
                
                guard let _ = htmlString.range(of: leftSideOfUsernameValue) else {
                    print("cannot find left range for username value")
                    return
                }
                
                guard let _ = htmlString.range(of: rightSideOfUsernameValue) else {
                    print("cannot find right range for username value")
                    return
                }
                
                guard let _ = htmlString.range(of: leftSideOfAvatarURLValue) else {
                    print("cannot find left range for avatar value")
                    return
                }
                
                guard let _ = htmlString.range(of: rightSideOfAvatarURLValue) else {
                    print("cannot find right range for avatar value")
                    return
                }
                
                guard let username = htmlString.slice(from: leftSideOfUsernameValue, to: rightSideOfUsernameValue) else {
                    print("cannot find username")
                    return
                }
                guard let avatarURL = htmlString.slice(from: leftSideOfAvatarURLValue, to: rightSideOfAvatarURLValue) else {
                    print("cannot find avatar url")
                    return
                }
                let newUser = User(name: username, iconImg: avatarURL)
                self.finalModerators.append(newUser)
                
                // This is where we decide to remove the start of the html string to get ready for the next loop around
                // to collect more usernames
                let endString = String(avatarURL + rightSideOfAvatarURLValue)
                
                if let indexEndOfPattern = htmlString.range(of: endString) {
                    let newText = String(htmlString[indexEndOfPattern.upperBound...])
                    htmlString = newText
                }
                
                
            }
            
            // update the users on screen after each 10
            self.updateData(on: self.finalModerators)
            
            if(isThereANextPage) {
                self.getModerators(url: newUrl!)
            }
            
            
        }
        
        task.resume()
        
    }
    
    func getUser(for username: String, completed: @escaping (Result<User, ErrorMessage>) -> Void) {
        
        let endpoint = baseURL + "\(userOption + username)/about.json"
        
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
            }
            
        }
        
        task.resume()
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModeratorCell.resuseID, for: indexPath) as! ModeratorCell
            cell.set(user: user)
            return cell
        })
    }
    
    func updateData(on moderators: [User]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.main])
        snapshot.appendItems(moderators)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        searchController.searchBar.placeholder  = "Search for a moderator"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController         = searchController
    }
    
}

extension ModListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredModerators : finalModerators
        let user        = activeArray[indexPath.item]
        
        
        let userInfoVC       = UserInfoVC()
        userInfoVC.user = user
        let navController = UINavigationController(rootViewController: userInfoVC)
        
        present(navController, animated: true)
    }
}

extension ModListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            return
        }
        isSearching = true
        filteredModerators = finalModerators.filter { $0.name.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredModerators)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: finalModerators)
    }
    
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
}
