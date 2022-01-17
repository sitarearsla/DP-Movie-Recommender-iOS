//
//  Movie.swift
//  MovieRecommender
//
//  Created by Sitare Arslanturk on 14.01.2022.
//

import Foundation

//movieId,title,genres
struct Movie {
    var movieId: String = ""
    var title: String = ""
    var genres: String = ""
    var rating = 0.0
    
    init(raw: [String]) {
        movieId = raw[0]
        title = raw[1]
        genres = raw[2]
    }
}
