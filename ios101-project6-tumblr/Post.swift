//
//  Post.swift
//  ios101-project6-tumblr
//

import Foundation

// Blog structure to match the raw JSON response
struct Blog: Decodable {
    let response: Response
}

struct Response: Decodable {
    let posts: [Post]
}

struct Post: Decodable {
    let summary: String
    let caption: String
    let photos: [Photo]
}

struct Photo: Decodable {
    let originalSize: PhotoInfo
    
    enum CodingKeys: String, CodingKey {
        case originalSize = "original_size"
    }
}

struct PhotoInfo: Decodable {
    let url: URL
}

