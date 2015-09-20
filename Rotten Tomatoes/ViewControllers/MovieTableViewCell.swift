//
//  MovieTableViewCell.swift
//  Rotten Tomatoes
//
//  Created by Amay Singhal on 9/17/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieTimeLabel: UILabel!
    @IBOutlet weak var movieThumbnailImageView: UIImageView!
    @IBOutlet weak var mpaaRatingImageView: UIImageView!
    @IBOutlet weak var critiqueRatingImageView: UIImageView!
    @IBOutlet weak var audienceRatingImageView: UIImageView!
    @IBOutlet weak var critqueScoreLabel: UILabel!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    @IBOutlet weak var movieCastLabel: UILabel!

}
