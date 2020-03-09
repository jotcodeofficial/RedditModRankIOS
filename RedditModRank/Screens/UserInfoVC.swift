//
//  UserInfoVC.swift
//  RedditModRank
//
//  Created by Work on 08/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let returnButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = returnButton
        print(user.name)
      
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    


}
