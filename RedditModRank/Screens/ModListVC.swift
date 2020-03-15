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
    var subredditData: Subreddit!// TODO
    
    let subredditStatsView         = UIView()

    private var firstIterationGetModerators = true
    private let network = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSubredditStatsView()
        configureSearchController()
        configureCollectionView()
        loadSubreddit(subreddit: subreddit)
        getModerators(url: URL(string: network.baseURL + network.subredditOption + subreddit + network.endSubModeratorsOption)!)
        configureDataSource()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureSubredditStatsView() {
        
        view.addSubview(subredditStatsView)
        subredditStatsView.layer.cornerRadius = 18
        subredditStatsView.backgroundColor = .secondarySystemBackground
        subredditStatsView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat    = 20
        
        NSLayoutConstraint.activate([
            
            subredditStatsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subredditStatsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            subredditStatsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            subredditStatsView.heightAnchor.constraint(equalToConstant: 250),
        
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureCollectionView() {

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ModeratorCell.self, forCellWithReuseIdentifier: ModeratorCell.resuseID)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: subredditStatsView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        ])
    }
    
    func loadSubreddit(subreddit: String) {
        network.getSubreddit(for: subreddit) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let subreddit):
                self.subredditData = subreddit
                DispatchQueue.main.async {
                    self.add(childVC: SubredditInfoHeaderVC(subreddit: subreddit), to: self.subredditStatsView)
                }
                
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentMRAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                    let navVC = SearchVC()
                    self.navigationController?.pushViewController(navVC, animated: true)
                }
            }
        }
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
                print(self.network.baseURL + self.network.subredditOption + self.subreddit + leftSideOfNextPageURLValue + newUrlId)
                newUrl = URL(string: self.network.baseURL + self.network.subredditOption + self.subreddit + leftSideOfNextPageURLValue + newUrlId)
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
