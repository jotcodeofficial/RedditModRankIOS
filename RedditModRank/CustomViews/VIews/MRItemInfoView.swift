//
//  MRItemInfoView.swift
//  RedditModRank
//
//  Created by Work on 14/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

enum ItemInfoType {
    case commentKarma, linkKarma, followers, following
}

class MRItemInfoView: UIView {

    let symbolImageView = UIImageView()
    let titleLabel      = MRTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel      = MRTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(symbolImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
            case .commentKarma:
                symbolImageView.image   = UIImage(systemName: SFSymbols.commentKarma)
                titleLabel.text         = "Comment Karma"
            case .linkKarma:
                symbolImageView.image   = UIImage(systemName: SFSymbols.linkKarma)
                titleLabel.text         = "Link Karma"
            case .following:
                symbolImageView.image   = UIImage(systemName: SFSymbols.following)
                titleLabel.text         = "Following"
            case .followers:
                symbolImageView.image   = UIImage(systemName: SFSymbols.followers)
                titleLabel.text         = "Followers"
        }
        countLabel.text                 = count.convertNumberToCommasString()
    }

}
