//
//  DataManager+Enum.swift
//  Pinsoft
//
//  Created by Ege Sucu on 6.08.2021.
//

import Foundation


enum FetchError: String, Error{
    case notFound = "Movie not found!"
    case tooManyResults = "Too many results."
}

enum SearchParameter : String {
    case s,i
}

enum NetworkError: Error{
    case invalidURL
    case invalidData
    case parseError
    case unknownError(String)
}
