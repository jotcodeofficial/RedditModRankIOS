//
//  Constants.swift
//  RedditModRank
//
//  Created by Work on 13/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

enum SFSymbols {
    static let location     = "mappin.and.ellipse"
    static let verified     = "checkmark.shield"
    static let unverified   = "xmark.shield"
    static let gold         = "star"
    static let noGold       = "star.slash"
    static let commentKarma = "text.bubble"
    static let linkKarma    = "text.quote"
    static let followers    = "heart"
    static let following    = "person.2"
    static let subscribers  = "person.3"
}

enum Images {
    static let logo = UIImage(named: "logo")
    static let emptyState = UIImage(named: "empty-state-logo")?.withTintColor(.systemGray4)
}


enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}


enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
