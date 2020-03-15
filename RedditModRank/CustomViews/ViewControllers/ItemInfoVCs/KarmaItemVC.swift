//
//  KarmaItemVC.swift
//  RedditModRank
//
//  Created by Work on 14/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class KarmaItemVC: MRItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .commentKarma, withCount: user.commentKarma ?? 0)
        itemInfoViewTwo.set(itemInfoType: .linkKarma, withCount: user.linkKarma ?? 0)
        actionButton.set(backgroundColor: .systemGreen, title: "Visit Profile", font: UIFont.preferredFont(forTextStyle: .headline))
    }
    
}
