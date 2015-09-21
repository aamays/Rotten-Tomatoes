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

    var movie: RTMovie! {
        didSet {
            updateCellWithMovie(movie)
        }
    }

    private func updateCellWithMovie(movie: RTMovie) {
        movieTitleLabel.text = movie.title

        movieTimeLabel.text = movie.getMovieRunningTimeString()

        if let audienceRating = movie.audienceRating {
            audienceRatingImageView.image = UIImage(named: audienceRating)
        }
        audienceScoreLabel.text = movie.audienceScorePct

        if let critiqueRating = movie.critiqueRating {
            critiqueRatingImageView.image = UIImage(named: critiqueRating)
        }
        critqueScoreLabel.text = movie.critiqueScorePct

        mpaaRatingImageView.contentMode = .ScaleAspectFit
        mpaaRatingImageView.image = UIImage(named: movie.mpaaRating)

        if let tnLink = movie.thumbnailLink {
            movieThumbnailImageView.contentMode = .ScaleAspectFit
            let urlRequest = NSURLRequest(URL: tnLink)
            movieThumbnailImageView.fadeInImageWithUrlRequest(urlRequest, forInterval: 1.0, placeholderImage: nil, success: nil, failure: nil)
        }

        movieCastLabel.text = movie.getCastActorNameConcatenatedString() ?? ""

    }
}
