//
//  SubredditInfoHeaderVC.swift
//  RedditModRank
//
//  Created by Work on 14/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class SubredditInfoHeaderMinimizedVC: UIViewController {
    
    let expandImageView = UIImageView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        layoutUI()
    }
    
    func addSubViews() {
        view.addSubview(expandImageView)
    }
    
    func layoutUI() {
        expandImageView.translatesAutoresizingMaskIntoConstraints = false
        expandImageView.image = SFSymbols.expand?.withTintColor(.systemTeal)
        
        NSLayoutConstraint.activate([
            expandImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            expandImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

    }
    
}
