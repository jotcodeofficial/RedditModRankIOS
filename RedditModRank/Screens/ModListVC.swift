//
//  ModListVC.swift
//  RedditModRank
//
//  Created by Work on 28/02/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class ModListVC: MRDataLoadingVC {
    
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
    var subredditData: Subreddit!
    
    let subredditStatsView          = UIView()
    let subredditStatsMinimizedView = UIView()
  
    private var containerViewHeight: NSLayoutConstraint!
    var innerMinView = UIView()
    var innerMaxView = UIView()
    var mainContainerView = UIView()
    var isViewTapped = false

    private var firstIterationGetModerators = true
    private let network = NetworkManager.shared
    
    init(subreddit: String) {
        super.init(nibName: nil, bundle: nil)
        self.subreddit  = subreddit
        title           = subreddit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO move this to the SearchVC - will stop the double errors also
        loadSubreddit(subreddit: subreddit)
        configureViewController()
        configureSearchController()
        configureMaxContainerView()
        configureInnerMinView()
        configureInnerMaxView()
        configureCollectionView()
        
        getModerators(url: URL(string: network.baseURL + network.subredditOption + subreddit + network.endSubModeratorsOption)!)
        configureDataSource()
        
    }
    
    
    @objc private func containerViewTapped() {
        isViewTapped.toggle()
        containerViewHeight.constant = self.isViewTapped ? 30 : 250

        print(self.isViewTapped)
        self.innerMinView.isHidden = !self.isViewTapped
        self.subredditStatsView.isHidden = self.isViewTapped
       }
    
    private func configureMaxContainerView() {
         mainContainerView = UIView()
         mainContainerView.translatesAutoresizingMaskIntoConstraints = false
         mainContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(containerViewTapped)))
         view.addSubview(mainContainerView)

         containerViewHeight = mainContainerView.heightAnchor.constraint(equalToConstant: 250)
         containerViewHeight.isActive = true

         NSLayoutConstraint.activate([
             mainContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             mainContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
             mainContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         ])
     }
    
    
    private func configureInnerMaxView() {

        subredditStatsView.layer.cornerRadius = 18
        subredditStatsView.backgroundColor = .secondarySystemBackground
        subredditStatsView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(subredditStatsView)

        NSLayoutConstraint.activate([
            subredditStatsView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor),
            subredditStatsView.heightAnchor.constraint(equalTo: mainContainerView.heightAnchor),
            subredditStatsView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            subredditStatsView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor)
        ])
        
    }
    
    private func configureInnerMinView() {
      
        subredditStatsMinimizedView.layer.cornerRadius = 9
        subredditStatsMinimizedView.backgroundColor = .secondarySystemBackground
        subredditStatsMinimizedView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(subredditStatsMinimizedView)
       
        NSLayoutConstraint.activate([
            subredditStatsMinimizedView.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor),
            subredditStatsMinimizedView.heightAnchor.constraint(equalTo: mainContainerView.heightAnchor),
            subredditStatsMinimizedView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            subredditStatsMinimizedView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor)
        ])
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
        
        containerViewHeight = subredditStatsView.heightAnchor.constraint(equalToConstant: 250)
        containerViewHeight.isActive = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.minimizeAction (_:)))
        self.subredditStatsView.addGestureRecognizer(gesture)

        let padding: CGFloat    = 20
        
        NSLayoutConstraint.activate([
            
            subredditStatsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subredditStatsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            subredditStatsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        
        // ShowLoadingView TODO
        PersistenceManager.updateWith(favorite: subredditData, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentMRAlertOnMainThread(title: "Success", message: "You have successfully saved \(self.subredditData.displayName)", buttonTitle: "Ok")
                return
            }
            
            self.presentMRAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    
    private func configureCollectionView() {

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ModeratorCell.self, forCellWithReuseIdentifier: ModeratorCell.resuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        ])
    }
    
    // TODO move this to the SearchVC
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
                    self.navigationController?.popViewController(animated: true)
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

extension ModListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredModerators.removeAll()
            updateData(on: finalModerators)
            isSearching = false
            return
        }
        isSearching = true
        filteredModerators = finalModerators.filter { $0.name.lowercased().starts(with: filter.lowercased()) }
        updateData(on: filteredModerators)
    }
    
    
}
