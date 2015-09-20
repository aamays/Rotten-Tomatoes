# Rotten-Tomatoes

A client application for Rotten Tomatoes API to display latest movie listings

Time spent: 12 hours
 * Functionality: ~4 hours
 * UI/UX: ~8 hours
 * Testing/Bug Fixes: ~1 hour

#### Completed:

* [x] User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
* [x] User can view movie details by tapping on a cell.
 * Hint: The Rotten Tomatoes API stopped returning high resolution images. To get around that, use the URL to the thumbnail poster, but replace 'tmb' with 'ori'.
* [x] User sees loading state while waiting for movies API. You can use one of the 3rd party libraries at https://www.cocoacontrols.com/search?q=hud.
* [x] User sees error message when there's a networking error. You may not use UIAlertView or a 3rd party library to display the error. See this screenshot for what the error message should look like: network error screenshot.
* [x] User can pull to refresh the movie list. Guide: Using UIRefreshControl
* [x] Add a tab bar for Box Office and DVD. (optional)
 * Implemented as UIPageViewController so that use can swipe between "Movies" and "Top DVDs" view
* [x] Add a search bar. (optional)
* [x] All images fade in (optional)
 * Implemented as <b>extension</b> to UIImageView and implemented a fade-in animation wrapper around  <code>- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest</code> method in AFNetworking.
* [x] Customize the highlight and selection effect of the cell. (optional)
* [x] Customize the navigation bar. (optional)
* [ ] Implement segmented control to switch between list view and grid view (optional)

#### Walkthrough:

![Video Walkthrough](RottenTomatoesDemo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

#### Development/Testing environment

* Operating System: Yosemite v10.10.4
* Xcode v7.0
* iOS v9.0
* Devices
 * iPhone 6 Simulator

#### Limitations & Further improvements to do:

* Support grid view viewing movies
