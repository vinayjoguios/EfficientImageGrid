//
//  APIEndpoints.swift
//  EfficientImageGrid

import Foundation

enum Environment  {
    case development
    case production
}

class NetworkManager {
    static var environment: Environment = .production
    
}

var baseURL: String {
    switch NetworkManager.environment {
    case .development: return  "https://acharyaprashant.org/api/"
    case .production: return "https://acharyaprashant.org/api/"
    }
}

enum APIEndpoints: String {
    
    case images = "v2/content/misc/media-coverages?limit=100"
    
    var url: String {
        return baseURL + self.rawValue
    }
}
