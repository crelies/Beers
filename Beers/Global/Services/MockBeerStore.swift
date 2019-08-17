//
//  MockBeerStore.swift
//  Beers
//
//  Created by Christian Elies on 07.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

final class MockBeerStore {
    let beers: [Beer]
    
    init() {
        let randomMax = Int.random(in: -1005 ... -1000)
        beers = Array(randomMax ... -995).map {
            let imageURL = URL(string: "https://images.punkapi.com/v2/8.png")!
            return Beer(id: $0,
                        name: "Beer No. \($0)",
                        tagline: "Awesome. Beer.",
                        firstBrewed: Date(),
                        description: "This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me.",
                        imageURL: imageURL)
        }
    }
}
