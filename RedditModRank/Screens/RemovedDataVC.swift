//
//  RemovedDataVC.swift
//  RedditModRank
//
//  Created by Work on 15/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class RemovedDataVC: MRDataLoadingVC {

    let network = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }


}
