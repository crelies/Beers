//
//  Beer+mock.swift
//  Beers
//
//  Created by Christian Elies on 22.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import Foundation

extension Beer {
    static func mock(id: Int = Int.random(in: -1000 ..< -1)) -> Beer {
        .init(
            id: id,
            name: "MockBeer",
            tagline: "Hey ho",
            firstBrewed: Date(),
            description: "A short description",
            imageURL: URL(string: "https://duckduckgo.com")!
        )
    }
}
