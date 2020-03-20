//
//  UIViewController+Ext.swift
//  RedditModRank
//
//  Created by Work on 01/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentMRAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = MRAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true, completion: nil)
    }
    
    func showEmptyState(with message: String, in view: UIView) {
        let emptyStateView = MREmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
}
