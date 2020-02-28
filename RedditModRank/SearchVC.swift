//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Sean Allen on 12/27/19.
//  Copyright © 2019 Sean Allen. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView       = UIImageView()
    let subredditTextField   = MRTextField()
    let callToActionButton  = MRButton(backgroundColor: .systemGreen, title: "View Mods")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")!
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func configureTextField() {
        view.addSubview(subredditTextField)
        
        NSLayoutConstraint.activate([
            subredditTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            subredditTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            subredditTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            subredditTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
