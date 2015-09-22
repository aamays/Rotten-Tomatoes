//
//  RTPageViewController.swift
//  Rotten Tomatoes
//
//  Created by Amay Singhal on 9/19/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class RTPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: - Properties
    let rtApiEndpoints = [(RTConstants.MoviesApiEndPointUrl, RTConstants.MovieTitleText), (RTConstants.TopDvdApiEndPointUrl, RTConstants.TopDvdTitleText)]
    var pageViewController:UIPageViewController!


    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var moviePageControl: UIPageControl!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pageViewController = storyboard?.instantiateViewControllerWithIdentifier(RTStoryboard.PageViewControllerIdentifier) as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self


        let initialViewController = movieViewControllerAtIndex(0)

        let viewControllers = [initialViewController]

        pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-25)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)

        // Update bar tint and color
        RTUitilities.updateTextAndTintColorForNavBar(navigationController, tintColor: nil, textColor: nil)
    }

    // MARK: - PageViewController datasource methods
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! MoviesViewController
        var index = viewController.pageIndex as Int

        if index == 0 || index == NSNotFound {
            return nil
        }

        return movieViewControllerAtIndex(--index)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! MoviesViewController
        var index = viewController.pageIndex as Int

        if index == NSNotFound || ++index == rtApiEndpoints.count {
            return nil
        }

        return movieViewControllerAtIndex(index)
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return rtApiEndpoints.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    // MARK: PageViewController deletgate methods
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = previousViewControllers.first as? MoviesViewController {
            if completed {
                let currentIndex = vc.pageIndex == 0 ? 1 : 0
                pageTitle.text = rtApiEndpoints[currentIndex].1
                moviePageControl.currentPage = currentIndex
            }
        }
    }
    // MARK: - Internal helper functions
    func movieViewControllerAtIndex(index: Int) -> MoviesViewController {
        let movieViewController = storyboard?.instantiateViewControllerWithIdentifier(RTStoryboard.MovieViewControllerIdentifier) as! MoviesViewController
        movieViewController.movieResultsApiUrl = rtApiEndpoints[index].0
        movieViewController.pageTitle = rtApiEndpoints[index].1
        movieViewController.pageIndex = index
        return movieViewController
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
