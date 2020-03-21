//
//  MRAlertContainerView.swift
//  RedditModRank
//
//  Created by Work on 20/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class MRAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
       backgroundColor       = .systemBackground
       layer.cornerRadius    = 16
       layer.borderWidth     = 2
       layer.borderColor     = UIColor.white.cgColor
       translatesAutoresizingMaskIntoConstraints = false
    }

}
