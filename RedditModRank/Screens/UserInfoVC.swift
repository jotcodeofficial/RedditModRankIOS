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
    let network = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let returnButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = returnButton
        print(user.name)
        loadUser(username: user.name)
        
        
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func loadUser(username: String) {
        network.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.user = user
                print(user)
                
                
            case .failure(let error):
                self.presentMRAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    
    
}
