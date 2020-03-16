//
//  MRInt+Ext.swift
//  RedditModRank
//
//  Created by Work on 16/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation


extension Int {

    func convertNumberToDate() -> String? {
        let date: Date? = Date(timeIntervalSince1970: Double(self))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        guard let validDate = date else { return "Invalid Date" }
        let localDate = dateFormatter.string(from: validDate)
        return localDate
    }
    
    func convertNumberToCommasString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return(numberFormatter.string(from: NSNumber(value: self))!)
    }
    
}
