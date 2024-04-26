//
//  APIResponse.swift
//  EfficientImageGrid

import Foundation
struct ApiResponse : Decodable {
    @DecodableDefault.False var status : Bool
    @DecodableDefault.EmptyString var message : String
}

struct ApiResponseObject<T : Decodable> : Decodable {
    @DecodableDefault.False var status : Bool
    @DecodableDefault.EmptyString var message : String
    let data : T?
}

struct ApiResponseArray<T : Decodable> : Decodable {
    @DecodableDefault.False var status : Bool
    @DecodableDefault.EmptyString var message : String
    let data : [T]?
}
