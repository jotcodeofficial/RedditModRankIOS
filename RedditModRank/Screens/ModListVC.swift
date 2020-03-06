//
//  ModListVC.swift
//  RedditModRank
//
//  Created by Work on 28/02/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class ModListVC: UIViewController {

    var subreddit: String!
    var simpleModerators: [Moderator] = []
    var finalModerators: [User] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getModerators()
        
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
        collectionView.register(ModeratorCell.self, forCellWithReuseIdentifier: ModeratorCell.resuseID)
    }
    
    func getModerators() {
          NetworkManager.shared.getModerators(for: subreddit) { result in
              
              switch result {
                  case .success(let moderators): do {
                      if (moderators.count <= 0) {
                                    self.presentMRAlertOnMainThread(title: "Whoops", message: ErrorMessage.noSubredditOrModerators.rawValue, buttonTitle: "Ok")
                                    return
                                }

                                self.simpleModerators.append(contentsOf: moderators)
                                
                                self.simpleModerators.forEach { (moderator) in
                                    NetworkManager.shared.getUser(for: moderator.name) { (result) in
                      
                                      switch result {
                                          case .success(let user): do {
                                              print("User\(user)")
                                              self.finalModerators.append(user)
                                              
                                          }
                                          case .failure(let error): do {
                                              switch error {
                                                  case .userDoesNotExist: do {
                                                      print("Error does not exist")
                                                  }
                                                  default: do {
                                                        self.presentMRAlertOnMainThread(title: "Whoops", message: error.rawValue, buttonTitle: "Ok")
                                                      }
                                              }
                                             
                                          }
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
    

}
