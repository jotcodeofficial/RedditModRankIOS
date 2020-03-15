//
//  StringHelpers.swift
//  RedditModRank
//
//  Created by Work on 14/03/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import Foundation

struct StringHelper {
    
    static func convertNumberToCommasString(inputNumber: Int!) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return(numberFormatter.string(from: NSNumber(value: inputNumber))!)
    }
    
    static func convertNumberToDate(inputNumber: Int!) -> String {
        let date = Date(timeIntervalSince1970: Double(inputNumber))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    
    
}
