//
//  ModeratorCell.swift
//  RedditModRank
//
//  Created by Work on 06/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class ModeratorCell: UICollectionViewCell {
    
    static let resuseID = "ModeratorCell"
    let avatarImageView = MRAvatarImageView(frame: .zero)
    let usernameLabel   = MRTitleLabel(textAlignment: .center, fontSize: 16)
    let network = NetworkManager.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(user: User) {
        usernameLabel.text = user.name
        if let iconURL = user.iconImg {
            network.downloadImage(from: String(iconURL.split(separator: "?")[0])) { [weak self] image in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
        }
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
