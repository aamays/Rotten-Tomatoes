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

    // MARK: - Outlets
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var searchBarTextField: UITextField!

    // MARK: - Properties
    var movieRefreshControl: UIRefreshControl?

    var movieResultsApiUrl: String!
    var pageIndex: Int!
    var pageTitle: String!

    var cachedMovies: [RTMovie]?
    var movies: [RTMovie]? {
        didSet {
            updateUI()
        }
    }

    struct ViewConfigParameters {
        static let AlterViewAlpha = CGFloat(0.8)
        static let PopupAlertTitle = "We've hit a snag"
        static let PopupAlertOkButtonText = "Ok"
        static let PopupAlertDefaultMessage = "Could not retreive movie data."
    }

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarTextField.delegate = self
        // Do any additional setup after loading the view.
        setUpMovieTableView()

        // load data using asyn call
        performAsyncRTMovieFetch("")

        movieResultsApiUrl = movieResultsApiUrl ?? RTConstants.MoviesApiEndPointUrl

    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RTUitilities.updateTextAndTintColorForNavBar(navigationController, tintColor: nil, textColor: nil)
    }

    // MARK: - Table View delegeate and datasource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let mCell = moviesTableView.dequeueReusableCellWithIdentifier(RTStoryboard.MovieCellIdentifier, forIndexPath: indexPath) as! MovieTableViewCell
        let movie = movies?[indexPath.row]
        mCell.movie = movie
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
        movieRefreshControl?.attributedTitle = NSAttributedString(string: withRefreshMessage ?? "")
        movieRefreshControl?.beginRefreshing()

        let task =  NSURLSession.sharedSession().dataTaskWithRequest( // fetches in background thread
            NSURLRequest(URL: NSURL(string: movieResultsApiUrl!)!),
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
                            print("Could not unwrap JSON...")
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
        var alertMessage = ViewConfigParameters.PopupAlertDefaultMessage
        var errorMessage = RTConstants.RequestFailedMessage
        if (error.code == NSURLErrorNotConnectedToInternet) {
            alertMessage = error.localizedDescription
            errorMessage = RTConstants.NetworkErrorMessage
        }

        errorMessageLabel?.attributedText = RTUitilities.getAttributedStringForAlertMessage(errorMessage)

        errorMessageView.alpha = ViewConfigParameters.AlterViewAlpha
        displayInformationalAlertView(alertMessage)
    }

    private func displayInformationalAlertView(withMessage: String) {
        let alert = UIAlertController(title: ViewConfigParameters.PopupAlertTitle, message: withMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ViewConfigParameters.PopupAlertOkButtonText, style: UIAlertActionStyle.Default, handler: nil))
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
