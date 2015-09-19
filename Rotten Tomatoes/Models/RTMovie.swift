//
//  Movie.swift
//  Rotten Tomatoes
//
//  Created by Amay Singhal on 9/17/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation

class RTMovie {

    var id: Int
    var title: String
    var summary: String
    var year: Int
    var ratings: NSDictionary

    var thumbnailLink: NSURL?
    var posterLink: NSURL? {
        // Since Rotten Toamatoes stopped returning URLs to the high resolution poster images,
        // following a get around to generate high resolution poster url from thumnail image.
        // Ideally, posterLink SHOULD be a 'Stored Property' and NOT a 'Computed Property'

        var thumbnailLinkUrl = thumbnailLink?.absoluteString ?? ""
        let range = thumbnailLinkUrl.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            thumbnailLinkUrl = thumbnailLinkUrl.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }

        return NSURL(string: thumbnailLinkUrl)
    }

    var audienceRating: String? {
        return ratings[MovieResponseKey.RatingTypeKeys.AudienceRating] as? String
    }

    var critiqueRating: String? {
        return ratings[MovieResponseKey.RatingTypeKeys.CritiqueRating] as? String
    }

    struct MovieResponseKey {
        static let Id = "id"
        static let Title = "title"
        static let Summary = "synopsis"
        static let PosterLinks = "posters"
        static let Year = "year"
        static let Ratings = "ratings"

        struct PosterTypeKeys {
            static let Detailed = "detailed"
            static let Original = "original"
            static let Profile = "profile"
            static let Thunbnail = "thumbnail"
        }

        struct RatingTypeKeys {
            static let AudienceRating = "audience_rating"
            static let CritiqueRating = "critics_rating"

        }
    }

    init(fromRottenTomatoesMovieResponse movieInfo: NSDictionary) {
        id = Int((movieInfo[MovieResponseKey.Id] as! String))!
        title = movieInfo[MovieResponseKey.Title] as! String
        summary = movieInfo[MovieResponseKey.Summary] as! String
        year = movieInfo[MovieResponseKey.Year] as! Int
        ratings = movieInfo[MovieResponseKey.Ratings] as! NSDictionary

        // assing poster links
        let posterLinks = movieInfo[MovieResponseKey.PosterLinks] as! NSDictionary
        thumbnailLink = NSURL(string: posterLinks[MovieResponseKey.PosterTypeKeys.Thunbnail] as! String)
    }

}