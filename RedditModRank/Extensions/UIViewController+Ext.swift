//
//  UIViewController+Ext.swift
//  RedditModRank
//
//  Created by Work on 01/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentMRAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = MRAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
}
