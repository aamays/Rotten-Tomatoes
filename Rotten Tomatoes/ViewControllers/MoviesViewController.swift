//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Amay Singhal on 9/16/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import AFNetworking
import LEColorPicker

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var searchBarTextField: UITextField!

    var movieRefreshControl: UIRefreshControl?

    var cachedMovies: [RTMovie]?
    var movies: [RTMovie]? {
        didSet {
            updateUI()
        }
    }

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarTextField.delegate = self
        // Do any additional setup after loading the view.
        setUpMovieTableView()

        // load data using asyn call
        performAsyncRTMovieFetch("")
    }

    // MARK: - Table View delegeate and datasource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let mCell = moviesTableView.dequeueReusableCellWithIdentifier(RTStoryboard.MovieCellIdentifier, forIndexPath: indexPath) as! MovieTableViewCell
        let movie = movies?[indexPath.row]
        mCell.movieTitleLabel.text = movie?.title
        mCell.movieSummaryLabel.text = movie?.summary
        if let tnLink = movie?.thumbnailLink {
            mCell.movieThumbnailImageView.contentMode = .ScaleAspectFit
            let urlRequest = NSURLRequest(URL: tnLink)
            mCell.movieThumbnailImageView.fadeInImageWithUrlRequest(urlRequest, forInterval: 1.0, placeholderImage: nil, success: nil, failure: nil)

        }

        return mCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        moviesTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Text field delegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - View Actions
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        performAsyncRTMovieFetch(RTConstants.ReleaseToRefreshText)
    }

    @IBAction func searchTextUpdated(sender: UITextField) {
        filterAndAssignResultsFromCachedData()
    }

    // MARK: - Helper Methods

    func setUpMovieTableView() {

        moviesTableView.delegate = self
        moviesTableView.dataSource = self

        // add refresh controller
        movieRefreshControl = UIRefreshControl()
        movieRefreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        moviesTableView.addSubview(movieRefreshControl!)


    }

    func updateUI() {
        errorMessageView.alpha = 0
        moviesTableView?.reloadData()
    }


    func performAsyncRTMovieFetch(withRefreshMessage: String?) {

        let urlString = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"

        movieRefreshControl?.attributedTitle = NSAttributedString(string: withRefreshMessage ?? "")
        movieRefreshControl?.beginRefreshing()

        let task =  NSURLSession.sharedSession().dataTaskWithRequest( // fetches in background thread
            NSURLRequest(URL: NSURL(string: urlString)!),
            completionHandler: {
                (rawMovieData, response, error) -> Void in
                // Sending the results back to main queue to update UI using the fetched data
                dispatch_async(dispatch_get_main_queue()) {
                    if let rawMovieData = rawMovieData  {
                        do {
                            if let apiDataDict = try NSJSONSerialization.JSONObjectWithData(rawMovieData, options: []) as? NSDictionary {
                                // extract movies from apiDataDict here and assign it to class variable
                                if let moviesDict = apiDataDict["movies"] as? [NSDictionary] {
                                    self.cachedMovies = moviesDict.map { RTMovie(fromRottenTomatoesMovieResponse: $0) }
                                    self.filterAndAssignResultsFromCachedData()
                                }
                            }
                        } catch {
                            print("Could not unwrap JSON!")
                        }
                    } else if let error = error {
                        self.updateUIForError(error)
                    }
                    self.movieRefreshControl?.endRefreshing()
                }
        })
        task.resume()
    }

    private func updateUIForError(error: NSError) {
        // @todo: Clean up following code to make it more concise (by probably using enums, we'll see)
        var alertMessage = "Could not retreive movie data."
        errorMessageLabel?.text = RTConstants.RequestFailedMessage
        if (error.code == NSURLErrorNotConnectedToInternet) {
            alertMessage = error.localizedDescription
            errorMessageLabel?.text = RTConstants.NetworkErrorMessage
        }

        errorMessageView.alpha = 0.8
        displayInformationalAlertView(alertMessage)
    }

    private func displayInformationalAlertView(withMessage: String) {
        let alert = UIAlertController(title: "We've hit a snag", message: withMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    private func filterAndAssignResultsFromCachedData() {
        let searchQuery = searchBarTextField.text?.lowercaseString ?? ""
        if (searchQuery.characters.count > 0) {
            movies = cachedMovies?.filter { $0.title.lowercaseString.rangeOfString(searchQuery.lowercaseString) != nil }
        } else {
            movies = cachedMovies
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch(segue.identifier!) {
        case RTStoryboard.ShowMovieDetailsSegueIdentifier:
            if let movieDetailVC = segue.destinationViewController as? MovieDetailsViewController {
                let indexPath = moviesTableView.indexPathForCell(sender as! UITableViewCell)
                movieDetailVC.movie = movies?[(indexPath?.row)!]
                searchBarTextField.resignFirstResponder()
                let cell = sender as! MovieTableViewCell
                movieDetailVC.placeHolderImage = cell.movieThumbnailImageView.image
            }
        default: ()
        }
    }

}
