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
}