//
//  Beer.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct Beer: Identifiable {
    let id: Int
    let name: String
    let tagline: String
    let firstBrewed: Date?
    let description: String
    let imageURL: URL?

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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        tagline = try container.decode(String.self, forKey: .tagline)
        do {
            firstBrewed = try container.decodeIfPresent(Date.self, forKey: .firstBrewed)
        } catch {
            // Some beers only return the year in which they have been brewed, like '2016'.
            firstBrewed = nil
        }
        description = try container.decode(String.self, forKey: .description)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
    }
}

extension Beer: Equatable {}

extension Beer: Hashable {}
