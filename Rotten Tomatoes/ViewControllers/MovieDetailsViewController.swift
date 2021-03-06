//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Amay Singhal on 9/18/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import LEColorPicker

class MovieDetailsViewController: UIViewController {


    // MARK: - Outlets
    @IBOutlet weak var movieDetailsScrollView: UIScrollView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieMpaaRatingImageView: UIImageView!
    @IBOutlet weak var movieSummaryLabel: UILabel!
    @IBOutlet weak var imageLoadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieSummarScrollView: UIScrollView!
    @IBOutlet weak var critiqueratingImageView: UIImageView!
    @IBOutlet weak var viewersRatingImageView: UIImageView!
    @IBOutlet weak var hudView: UIView!

    // MARK: - Properties
    struct ViewConfigParameters {
        static let HUDViewCornerRadius = CGFloat(10)
        static let ScrollViewAplha = CGFloat(0.85)
        static let ScrollViewInitialSlideDistance = CGFloat(370)
        static let ScrollViewToggleSlideDistance = CGFloat(290)
        static let ScollViewPadding = CGFloat(10)
        static let MoviePosterFadeInInterval = 2.0
        static let DefaultNavigationTitleText = "Details"
    }

    var movie: RTMovie?
    var colorPicker = LEColorPicker()
    var partialSCViewDisplayed = false
    var placeHolderImage: UIImage?

    var backgroundColorForMovieDetails: UIColor? {
        get {
            return movieDetailsScrollView?.backgroundColor
        }
        set(newValue) {
            movieDetailsScrollView?.backgroundColor = newValue
            movieDetailsScrollView?.alpha = ViewConfigParameters.ScrollViewAplha
            navigationController?.navigationBar.barTintColor = newValue
        }
    }

    var secondaryColorForMovieText: UIColor? {
        get {
            return movieSummaryLabel?.textColor
        }
        set(newValue) {
            movieTitleLabel?.textColor = newValue
            runtimeLabel?.textColor = newValue
            movieSummaryLabel?.textColor = newValue
            movieYearLabel?.textColor = newValue
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: newValue ?? UIColor.darkGrayColor()]
        }
    }

    // MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        hudView.layer.cornerRadius = ViewConfigParameters.HUDViewCornerRadius
        // Do any additional setup after loading the view.
        if let _ = movie {
            // updateUI()
            loadImageAndUpdateView()
        }
    }

    // MARK: - View Actions
    @IBAction func scrollViewTapped() {
        slideMovieDetailScore(partialSCViewDisplayed ? ViewConfigParameters.ScrollViewToggleSlideDistance : -ViewConfigParameters.ScrollViewToggleSlideDistance)
        partialSCViewDisplayed = !partialSCViewDisplayed
    }

    @IBAction func ImageViewTapped() {
        if partialSCViewDisplayed {
            scrollViewTapped()
        }
    }

    // MARK: - Internal methods
    private func loadImageAndUpdateView() {
        let urlRequest = NSURLRequest(URL: (movie?.posterLink!)!)

        movieImage.fadeInImageWithUrlRequest(urlRequest, forInterval: ViewConfigParameters.MoviePosterFadeInInterval, placeholderImage: placeHolderImage, success: { (request, response, posterImage) -> Void in
            self.updateUIWithImage(posterImage)
            self.imageLoadingActivityIndicator.stopAnimating()
            self.hudView.alpha = 0
            }) { (request, response, error) -> Void in
                // @todo: Handle error case
        }
    }

    private func updateUIWithImage(image: UIImage) {
        // Set image view elements
        self.title = movie?.title ?? ViewConfigParameters.DefaultNavigationTitleText

        // Set scroll view elements
        movieTitleLabel.text = movie?.title
        runtimeLabel.text = movie?.getMovieRunningTimeString()
        if let yr = movie?.year {
            movieYearLabel.text = "\(yr)"
        }

        if let audienceRating = movie?.audienceRating {
            viewersRatingImageView.image = UIImage(named: audienceRating)
        }

        if let critiqueRating = movie?.critiqueRating {
            critiqueratingImageView.image = UIImage(named: critiqueRating)
        }

        if let mpaaRating = movie?.mpaaRating {
            movieMpaaRatingImageView.contentMode = .ScaleAspectFit
            movieMpaaRatingImageView.image = UIImage(named: mpaaRating)
        }

        let movieCastStr = movie?.getCastActorNameConcatenatedString()
        let movieSummary = movie?.summary
        setSummaryLabelTextWithCastString(movieCastStr ?? RTConstants.NotAvailableLong, andSynopsis: movieSummary ?? RTConstants.NotAvailableLong)
        movieSummaryLabel.sizeToFit()
        movieSummarScrollView.contentSize = CGSize(width: movieSummaryLabel.bounds.width, height: movieSummaryLabel.bounds.height + ViewConfigParameters.ScollViewPadding)
        movieSummarScrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight

        // select color scheme and apply colors
        let colorScheme = colorPicker.colorSchemeFromImage(image)
        backgroundColorForMovieDetails = colorScheme.backgroundColor
        secondaryColorForMovieText = colorScheme.secondaryTextColor

        slideMovieDetailScore(ViewConfigParameters.ScrollViewInitialSlideDistance)
    }

    private func setSummaryLabelTextWithCastString(cast: String, andSynopsis synopsis: String) {
        let attributedString = NSMutableAttributedString()
        let attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(18)]

        // cast
        let castTitleStr = NSMutableAttributedString(string:"Cast:", attributes:attrs)
        attributedString.appendAttributedString(castTitleStr)
        attributedString.appendAttributedString(NSAttributedString(string: " \(cast)\n\n"))

        // synopsis
        let synopsisTitleStr = NSMutableAttributedString(string:"Synopsis:", attributes:attrs)
        attributedString.appendAttributedString(synopsisTitleStr)
        attributedString.appendAttributedString(NSAttributedString(string: " \(synopsis)"))
        movieSummaryLabel.attributedText = attributedString
    }

    private func slideMovieDetailScore(distance: CGFloat) {
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 7, options: [], animations: {
            self.movieDetailsScrollView.frame.origin.y += distance
        }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
