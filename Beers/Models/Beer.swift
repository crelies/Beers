//
//  Beer.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

final class Beer: Identifiable {
    let id: Int // Identifiable
    let name: String
    let tagline: String
    let firstBrewed: Date
    let description: String
    let imageURL: URL
    
    lazy var beerImage: BeerImageModel = {
        return BeerImageModel(imageURL: imageURL)
    }()
    
    init(id: Int,
         name: String,
         tagline: String,
         firstBrewed: Date,
         description: String,
         imageURL: URL) {
        self.id = id
        self.name = name
        self.tagline = tagline
        self.firstBrewed = firstBrewed
        self.description = description
        self.imageURL = imageURL
    }
}

extension Beer: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case tagline
        case firstBrewed = "first_brewed"
        case description
        case imageURL = "image_url"
    }
}
