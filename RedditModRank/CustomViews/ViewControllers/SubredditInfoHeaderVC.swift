//
//  SubredditInfoHeaderVC.swift
//  RedditModRank
//
//  Created by Work on 14/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class SubredditInfoHeaderVC: UIViewController {

        let avatarImageView     = MRAvatarImageView(frame: .zero)
        let usernameLabel       = MRTitleLabel(textAlignment: .left, fontSize: 34)
        let nameLabel           = MRSecondaryTitleLabel(fontSize: 18)
        let locationImageView   = UIImageView()
        let goldImageView       = UIImageView()
        let locationLabel       = MRSecondaryTitleLabel(fontSize: 18)
        let bioLabel            = MRBodyLabel(textAlignment: .left)
        let commentsButton      = MRButton()
        let linksButton         = MRButton()
        let stackView           = UIStackView()
        
        var subreddit: Subreddit!
        
        init(subreddit: Subreddit) {
            super.init(nibName: nil, bundle: nil)
            self.subreddit = subreddit
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            addSubViews()
            layoutUI()
            configureUIElements()
            configureBackgroundView()
            configureButtons()
            configureStackView()
        }
    
    private func configureStackView() {
        stackView.axis          = .horizontal
        stackView.distribution  = .fillEqually
        stackView.spacing = 10
        
        stackView.addArrangedSubview(commentsButton)
        stackView.addArrangedSubview(linksButton)
    }
    
    private func configureButtons() {
        commentsButton.set(backgroundColor: .systemGreen, title: "Removed Comments", font: UIFont.preferredFont(forTextStyle: .footnote))
        linksButton.set(backgroundColor: .systemPurple, title: "Removed Threads", font: UIFont.preferredFont(forTextStyle: .footnote))
        linksButton.titleLabel?.font.withSize(6)
    }
    
        private func configureBackgroundView() {
            view.layer.cornerRadius = 18
            view.backgroundColor = .secondarySystemBackground
        }
        
        func configureUIElements() {
            avatarImageView.downloadImage(from: (subreddit.communityIcon ?? "").isEmpty ? subreddit.iconImg! : subreddit.communityIcon!)
            usernameLabel.text          = subreddit.displayName
            nameLabel.text              = "Created " + StringHelper.convertNumberToDate(inputNumber: subreddit.createdUtc ?? 0)
            locationLabel.text          = StringHelper.convertNumberToCommasString(inputNumber: subreddit.subscribers ?? 0)
            bioLabel.text               = (subreddit.publicDescription ?? "").isEmpty ?  "No public description" : subreddit.publicDescription
            bioLabel.numberOfLines      = 3
            
            locationImageView.image     = UIImage(systemName: SFSymbols.subscribers)
            locationImageView.tintColor = .secondaryLabel
       
        }
        
        func addSubViews() {
            view.addSubview(avatarImageView)
            view.addSubview(usernameLabel)
            view.addSubview(nameLabel)
            view.addSubview(locationImageView)
            view.addSubview(locationLabel)
            view.addSubview(bioLabel)
            view.addSubview(stackView)
        }
        
        func layoutUI() {
            let padding: CGFloat            = 20
            let textImagePadding: CGFloat   = 12
            locationImageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
                avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                avatarImageView.widthAnchor.constraint(equalToConstant: 90),
                avatarImageView.heightAnchor.constraint(equalToConstant: 90),
                
                usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
                usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
                usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                usernameLabel.heightAnchor.constraint(equalToConstant: 38),
                
                
                nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
                nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
                nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                nameLabel.heightAnchor.constraint(equalToConstant: 20),
                
                
                locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
                locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
                locationImageView.widthAnchor.constraint(equalToConstant: 40),
                locationImageView.heightAnchor.constraint(equalToConstant: 20),
                
                locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
                locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
                locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                locationLabel.heightAnchor.constraint(equalToConstant: 20),
                
                bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
                bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                bioLabel.heightAnchor.constraint(equalToConstant: 60),
                
                stackView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: textImagePadding),
                stackView.leadingAnchor.constraint(equalTo: bioLabel.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                stackView.heightAnchor.constraint(equalToConstant: 40),
            ])
        }
    

        
        
        


    }
