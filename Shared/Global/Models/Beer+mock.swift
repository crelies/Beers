//
//  Beer+mock.swift
//  Beers
//
//  Created by Christian Elies on 22.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import Foundation

extension Beer {
    static func mock() -> Beer {
        .init(
            id: Int.random(in: -1000 ..< -999),
            name: "MockBeer",
            tagline: "Hey ho",
            firstBrewed: Date(),
            description: "A short description",
            imageURL: URL(string: "https://duckduckgo.com")!
        )
    }
}
