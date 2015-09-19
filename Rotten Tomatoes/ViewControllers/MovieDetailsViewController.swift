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


    @IBOutlet weak var movieDetailsScrollView: UIScrollView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var movieSummaryLabel: UILabel!
    @IBOutlet weak var imageLoadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieSummarScrollView: UIScrollView!
    @IBOutlet weak var critiqueratingImageView: UIImageView!
    @IBOutlet weak var viewersRatingImageView: UIImageView!

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
            movieDetailsScrollView?.alpha = 0.85
        }
    }

    var secondaryColorForMovieText: UIColor? {
        get {
            return movieSummaryLabel?.textColor
        }
        set(newValue) {
            movieTitleLabel?.textColor = newValue
            yearLabel?.textColor = newValue
            movieSummaryLabel?.textColor = newValue
        }
    }

    struct MovieDetailsConstants {
        static let ScrollViewFrameSlideDistance = CGFloat(290)
    }

    // MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let _ = movie {
            // updateUI()
            self.title = movie?.title ?? "Details"
            loadImageAndUpdateView()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func loadImageAndUpdateView() {
        let urlRequest = NSURLRequest(URL: (movie?.posterLink!)!)
        print(placeHolderImage)
        movieImage.fadeInImageWithUrlRequest(urlRequest, forInterval: 2.0, placeholderImage: placeHolderImage, success: { (request, response, posterImage) -> Void in
                self.updateUIWithImage(posterImage)
                self.imageLoadingActivityIndicator.stopAnimating()
            }) { (request, response, error) -> Void in
                // @todo: Handle error case
        }
    }

    func updateUIWithImage(image: UIImage) {

        // Set image view elements
        // movieImage.image = image

        // Set scroll view elements
        movieTitleLabel.text = movie?.title
        if let movieYear = movie?.year {
            yearLabel.text = "\(movieYear)"
        }

        if let audienceRating = movie?.audienceRating {
            viewersRatingImageView.image = UIImage(named: audienceRating)
        }

        if let critiqueRating = movie?.critiqueRating {
            critiqueratingImageView.image = UIImage(named: critiqueRating)
        }

        movieSummaryLabel.text = movie?.summary
        movieSummaryLabel.sizeToFit()
        movieSummarScrollView.contentSize = CGSize(width: movieSummaryLabel.bounds.width, height: movieSummaryLabel.bounds.height + 10)
        movieSummarScrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight

        // select color scheme and apply colors
        let colorScheme = colorPicker.colorSchemeFromImage(image)
        backgroundColorForMovieDetails = colorScheme.backgroundColor
        secondaryColorForMovieText = colorScheme.secondaryTextColor

        scrollViewTapped()
    }

    @IBAction func scrollViewTapped() {

        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 7, options: [], animations: {
            self.movieDetailsScrollView.frame.origin.y += self.partialSCViewDisplayed ? -MovieDetailsConstants.ScrollViewFrameSlideDistance : MovieDetailsConstants.ScrollViewFrameSlideDistance
        }, completion: nil)

        partialSCViewDisplayed = !partialSCViewDisplayed
    }

    @IBAction func ImageViewTapped() {
        if !partialSCViewDisplayed {
            scrollViewTapped()
        }
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
