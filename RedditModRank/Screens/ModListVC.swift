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
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getModerators()
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
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ModeratorCell.self, forCellWithReuseIdentifier: ModeratorCell.resuseID)
    }
    
    

    
    
    func getModerators() {
          NetworkManager.shared.getModerators(for: subreddit) { [weak self] result in
            guard let self = self else { return }
            
              switch result {
                  case .success(let moderators): do {
                       if (moderators.count <= 0) {
                            self.presentMRAlertOnMainThread(title: "Whoops", message: ErrorMessage.noSubredditOrModerators.rawValue, buttonTitle: "Ok")
                            return
                        }

                        self.simpleModerators.append(contentsOf: moderators)
                        
                        //self.simpleModerators.forEach { (moderator) in
                    for (idx, element) in (self.simpleModerators.enumerated()) {
                            NetworkManager.shared.getUser(for: element.name) { [weak self] result in
                                guard let self = self else { return }
                                  switch result {
                                      case .success(let user): do {
                                          self.finalModerators.append(user)
                                          
                                      }
                                      case .failure(let error): do {
                                          switch error {
                                              case .userDoesNotExist: do {
                                                  print("Error does not exist")
                                              }
                                              default: do {
                                                print(error.localizedDescription)
                                                  self.presentMRAlertOnMainThread(title: "Whoops", message: error.rawValue, buttonTitle: "Ok")
                                              }
                                          }
                                    
                                      }
                             
                                  }
                                if idx == (self.simpleModerators.endIndex)-1 {
                                    // handling the last element
                                    self.updateData()
                                 }
                            
                            }
                        }
                  }
                  case .failure(let error): do {
                      self.presentMRAlertOnMainThread(title: "Whoops", message: error.rawValue, buttonTitle: "Ok")
                  }
              }

              
              
          }
    
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ModeratorCell.resuseID, for: indexPath) as! ModeratorCell
            cell.set(user: user)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.main])
        snapshot.appendItems(finalModerators)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func configureSearchController() {
        
    }

}
