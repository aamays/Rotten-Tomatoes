//
//  Movie.swift
//  Rotten Tomatoes
//
//  Created by Amay Singhal on 9/17/15.
//  Copyright © 2015 ple. All rights reserved.
//

import Foundation

class RTMovie {

    // MARK: - Properties
    var id: Int
    var title: String
    var summary: String
    var year: Int
    var ratings: NSDictionary
    var mpaaRating: String
    var cast: [NSDictionary]
    var movieTimeInMinutes: Int
    var movieTimeInSeconds: Int {
        return movieTimeInMinutes * 60
    }

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

    var audienceScorePct: String? {
        if let audienceScore = ratings[MovieResponseKey.RatingTypeKeys.AudienceScore] as? Int {
            return "\(audienceScore)%"
        }
    
        return RTConstants.NotAvailableShort
    }

    var critiqueScorePct: String? {
        if let critiqueScore = ratings[MovieResponseKey.RatingTypeKeys.CritiqueScore] as? Int {
            return "\(critiqueScore)%"
        }
        
        return RTConstants.NotAvailableShort
    }

    struct MovieResponseKey {
        static let Id = "id"
        static let Title = "title"
        static let Summary = "synopsis"
        static let PosterLinks = "posters"
        static let Year = "year"
        static let Ratings = "ratings"
        static let MpaaRatings = "mpaa_rating"
        static let AbridgedCast = "abridged_cast"
        static let Runtime = "runtime"

        struct PosterTypeKeys {
            static let Detailed = "detailed"
            static let Original = "original"
            static let Profile = "profile"
            static let Thunbnail = "thumbnail"
        }

        struct RatingTypeKeys {
            static let AudienceRating = "audience_rating"
            static let AudienceScore = "audience_score"
            static let CritiqueRating = "critics_rating"
            static let CritiqueScore = "critics_score"

        }

        struct CastKeys {
            static let Name = "name"
            
        }
    }

    // MARK: - Initializer
    init(fromRottenTomatoesMovieResponse movieInfo: NSDictionary) {
        id = Int((movieInfo[MovieResponseKey.Id] as! String))!
        title = movieInfo[MovieResponseKey.Title] as! String
        summary = movieInfo[MovieResponseKey.Summary] as! String
        year = movieInfo[MovieResponseKey.Year] as! Int
        ratings = movieInfo[MovieResponseKey.Ratings] as! NSDictionary
        mpaaRating = movieInfo[MovieResponseKey.MpaaRatings] as! String
        movieTimeInMinutes = movieInfo[MovieResponseKey.Runtime] as! Int

        // assing poster links
        let posterLinks = movieInfo[MovieResponseKey.PosterLinks] as! NSDictionary
        thumbnailLink = NSURL(string: posterLinks[MovieResponseKey.PosterTypeKeys.Thunbnail] as! String)

        // Assing cast
        cast = movieInfo[MovieResponseKey.AbridgedCast] as! [NSDictionary]

    }

    // MARK: - Methods
    func getCastActorNameConcatenatedString() -> String {
        return (cast.map { $0[MovieResponseKey.CastKeys.Name] as! String }).joinWithSeparator(", ")
    }

    func getMovieRunningTimeString() -> String {
        let (h, m) =  (movieTimeInSeconds / 3600, (movieTimeInSeconds % 3600) / 60)
        return "\(h) hr. \(m) min."
    }

}