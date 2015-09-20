//
//  RTUtils.swift
//  Rotten Tomatoes
//
//  Created by Amay Singhal on 9/16/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import Foundation


struct RTStoryboard {
    static let MovieCellIdentifier = "MovieCell"
    static let ShowMovieDetailsSegueIdentifier = "Show Movie Details"
    static let PageViewControllerIdentifier = "RTPageViewController"
    static let MovieViewControllerIdentifier = "MoviesViewController"
}

struct RTConstants {
    static let LoadingText = "Loading"
    static let ReleaseToRefreshText = "Release to refresh"
    static let RequestFailedMessage = "Request Failed"
    static let NetworkErrorMessage = "Network Error"
    static let NotAvailableShort = "N/A"
    static let MovieTitleText = "Movie"
    static let TopDvdTitleText = "Top DVD"
    static let MoviesApiEndPointUrl = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
    static let TopDvdApiEndPointUrl = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"
    static let ApplicationBarTintColor = UIColor(red: 255/255, green: 204/255, blue: 102/255, alpha: 1)
}