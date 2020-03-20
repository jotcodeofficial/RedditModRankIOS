//
//  FavoriteCell.swift
//  RedditModRank
//
//  Created by Work on 19/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    static let resuseID = "FavoriteCell"
    let avatarImageView = MRAvatarImageView(frame: .zero)
    let subredditLabel  = MRTitleLabel(textAlignment: .center, fontSize: 26)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: Subreddit) {
        subredditLabel.text = favorite.displayName
        avatarImageView.downloadImage(from: (favorite.communityIcon ?? "").isEmpty ? favorite.iconImg! : favorite.communityIcon!)
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(subredditLabel)
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            subredditLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            subredditLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            subredditLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            subredditLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
