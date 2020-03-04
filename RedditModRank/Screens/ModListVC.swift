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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
    
        
        NetworkManager.shared.getModerators(for: subreddit) { (moderators, errorMessage) in
            guard let moderators = moderators else {
                print(errorMessage!)
                self.presentMRAlertOnMainThread(title: "Whoops", message: errorMessage!.rawValue, buttonTitle: "Ok")
                return
            }
            if (moderators.count <= 0) {
                self.presentMRAlertOnMainThread(title: "Whoops", message: "This subreddit does not seem to exist, or has no moderators!", buttonTitle: "Ok")
                return
            }

            self.simpleModerators.append(contentsOf: moderators)
            
            self.simpleModerators.forEach { (moderator) in
                NetworkManager.shared.getUser(for: moderator.name) { (user, errorMessage) in
  
                    guard let user = user else {
                        print("RAW \(errorMessage?.rawValue)")
                     return
                    }
                    print(user)

                    self.finalModerators.append(user)

                }
            }
            
        }
  

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

}
