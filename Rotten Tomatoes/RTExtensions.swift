//
//  RTUtils.swift
//  Rotten Tomatoes
//
//  Created by Amay Singhal on 9/17/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

extension UIImageView {

    func fadeInImageWithUrlRequest(urlRequest: NSURLRequest, forInterval interval: NSTimeInterval, placeholderImage: UIImage?, success: ((NSURLRequest, NSHTTPURLResponse, UIImage) -> Void)?, failure: ((NSURLRequest, NSHTTPURLResponse, NSError) -> Void)?) -> Void {
        self.setImageWithURLRequest(urlRequest, placeholderImage: placeholderImage, success: { (request, response, posterImage) -> Void in
                self.image = posterImage
                UIView.animateWithDuration(interval, animations: { () -> Void in
                    self.alpha = 1
                })
                success?(request, response, posterImage)
            }) { (request, response, error) -> Void in
                // @todo: Handle error case
                failure?(request, response, error)
        }
    }

}