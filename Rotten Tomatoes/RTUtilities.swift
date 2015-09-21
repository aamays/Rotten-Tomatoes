//
//  RTUtilities.swift
//  Rotten Tomatoes
//
//  Created by Amay Singhal on 9/19/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation
import UIKit


class RTUitilities {

    static func updateTextAndTintColorForNavBar(navController: UINavigationController?, tintColor: UIColor?, textColor: UIColor?) {
        navController?.navigationBar.barTintColor = tintColor ?? RTConstants.ApplicationBarTintColor
        navController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textColor ?? UIColor.darkGrayColor()]
    }

    static func getAttributedStringForAlertMessage(message: String, withIconSize size: CGFloat = 17, andBaseLine baseline: CGFloat = -3) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        if let font = UIFont(name: "fontastic", size: size) {
            let attrs = [NSFontAttributeName : font,
                NSBaselineOffsetAttributeName: baseline]
            let cautionSign = NSMutableAttributedString(string: "a", attributes: attrs)
            attributedString.appendAttributedString(cautionSign)
            attributedString.appendAttributedString(NSAttributedString(string: " "))
        }

        attributedString.appendAttributedString(NSAttributedString(string: message))
        return attributedString
    }
}