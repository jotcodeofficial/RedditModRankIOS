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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getModerators(for: subreddit) { (moderators, errorMessage) in
            guard let moderators = moderators else {
                print(errorMessage!)
                self.presentMRAlertOnMainThread(title: "bad stuff happened", message: errorMessage!, buttonTitle: "Ok")
                return
            }
            print("Moderators.count = \(moderators.count)")
            print(moderators)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

}
