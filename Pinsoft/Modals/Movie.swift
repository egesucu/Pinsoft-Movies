//
//  Movie.swift
//  Pinsoft
//
//  Created by Ege Sucu on 4.08.2021.
//

import Foundation

struct MovieList : Decodable{
    
    var response: String
    var search: [ShortMovie]?
    var error : String?
    
    enum CodingKeys: String,CodingKey{
        case search = "Search"
        case response = "Response"
        case error = "Error"
    }
}

struct ShortMovie: Decodable {
    var year: String
    var title: String
    var imdbID: String
    var image: String
    
    enum CodingKeys : String, CodingKey{
        case title = "Title"
        case year = "Year"
        case image = "Poster"
        case imdbID
    }
}

struct Movie : Decodable {
    
    var year: String
    var title: String
    var image: String
    var imdbID: String
    var genre: String
    var ratings: [Rating]
    var description: String
    var error : String?
    
    enum CodingKeys : String, CodingKey{
        case title = "Title"
        case year = "Year"
        case image = "Poster"
        case ratings = "Ratings"
        case genre = "Genre"
        case imdbID
        case description = "Plot"
        case error = "Error"
    }
    
}


struct Rating : Decodable{
    var source: String
    var value: String
    
    enum CodingKeys: String, CodingKey{
        case source = "Source"
        case value = "Value"
    }
    
    
    
}
