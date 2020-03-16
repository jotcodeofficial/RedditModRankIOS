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
    
    let headerView          = UIView()
    let itemViewOne         = UIView()
    let dateLabel           = MRBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        layoutUI()
        loadUser(username: user.name)
     
        
    }
    
    func configureViewController() {
           view.backgroundColor = .systemBackground
           let returnButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
           navigationItem.leftBarButtonItem = returnButton
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, dateLabel]
        
        let padding: CGFloat    = 20
        let itemHeight: CGFloat = 140
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
        
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func loadUser(username: String) {
        network.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                //self.user = user
                print(user)
                DispatchQueue.main.async {
                    self.add(childVC: MRUserInfoHeaderVC(user: user), to: self.headerView)
                    self.add(childVC: KarmaItemVC(user: user), to: self.itemViewOne)
                    self.dateLabel.text = "Created on " +  user.createdUtc!.convertNumberToDate()!
                }
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.presentMRAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    
    
    
    
}
