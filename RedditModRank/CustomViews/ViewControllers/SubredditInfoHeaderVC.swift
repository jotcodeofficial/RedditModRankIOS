//
//  SubredditInfoHeaderVC.swift
//  RedditModRank
//
//  Created by Work on 14/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class SubredditInfoHeaderVC: UIViewController {

        let avatarImageView             = MRAvatarImageView(frame: .zero)
        let subredditLabel              = MRTitleLabel(textAlignment: .left, fontSize: 34)
        let createdAtLabel              = MRSecondaryTitleLabel(fontSize: 18)
        let subscribersIconImageView    = UIImageView()
        let subscribersCountLabel       = MRSecondaryTitleLabel(fontSize: 18)
        let bioLabel                    = MRBodyLabel(textAlignment: .left)
        let commentsButton              = MRButton()
        let linksButton                 = MRButton()
        let stackView                   = UIStackView()
        let network                     = NetworkManager.shared

        
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
            setSubredditImage(subredditImageURLString: (subreddit.communityIcon ?? "").isEmpty ? subreddit.iconImg! : subreddit.communityIcon!)
            subredditLabel.text          = subreddit.displayName
            createdAtLabel.text              = "Created " + (subreddit.createdUtc?.convertNumberToDate())!
            subscribersCountLabel.text          = subreddit.subscribers?.convertNumberToCommasString()
            bioLabel.text               = (subreddit.publicDescription ?? "").isEmpty ?  "No public description" : subreddit.publicDescription
            bioLabel.numberOfLines      = 3
            
            subscribersIconImageView.image     = SFSymbols.subscribers
            subscribersIconImageView.tintColor = .secondaryLabel
       
        }
    
        func setSubredditImage(subredditImageURLString: String) {
            network.downloadImage(from: subredditImageURLString) { [weak self] image in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
        }
        
        func addSubViews() {
            view.addSubview(avatarImageView)
            view.addSubview(subredditLabel)
            view.addSubview(createdAtLabel)
            view.addSubview(subscribersIconImageView)
            view.addSubview(subscribersCountLabel)
            view.addSubview(bioLabel)
            view.addSubview(stackView)
        }
        
        func layoutUI() {
            let padding: CGFloat            = 20
            let textImagePadding: CGFloat   = 12
            subscribersIconImageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
                avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                avatarImageView.widthAnchor.constraint(equalToConstant: 90),
                avatarImageView.heightAnchor.constraint(equalToConstant: 90),
                
                subredditLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
                subredditLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
                subredditLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                subredditLabel.heightAnchor.constraint(equalToConstant: 38),
                
                
                createdAtLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
                createdAtLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
                createdAtLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                createdAtLabel.heightAnchor.constraint(equalToConstant: 20),
                
                
                subscribersIconImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
                subscribersIconImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
                subscribersIconImageView.widthAnchor.constraint(equalToConstant: 40),
                subscribersIconImageView.heightAnchor.constraint(equalToConstant: 20),
                
                subscribersCountLabel.centerYAnchor.constraint(equalTo: subscribersIconImageView.centerYAnchor),
                subscribersCountLabel.leadingAnchor.constraint(equalTo: subscribersIconImageView.trailingAnchor, constant: 5),
                subscribersCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                subscribersCountLabel.heightAnchor.constraint(equalToConstant: 20),
                
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
