//
//  MRAvatarImageView.swift
//  RedditModRank
//
//  Created by Work on 06/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class MRAvatarImageView: UIImageView {

    let cache            = NetworkManager.shared.cache
    let placeholderImage = Images.avatarPlaceholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

}
