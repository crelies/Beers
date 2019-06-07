//
//  MockBeerStore.swift
//  Beers
//
//  Created by Christian Elies on 07.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

final class MockBeerStore: BeerStore {
    init() {
        let dependencies = BeerStoreDependencies()
        super.init(dependencies: dependencies)
        
        let randomMax = Int.random(in: -1005 ... -1000)
        beers = Array(randomMax ... -995).map {
            let imageURL = URL(string: "https://broughtonales.co.uk/wp-content/uploads/2016/02/merlins_ale.png")!
            return Beer(id: $0,
                        name: "Beer No. \($0)",
                        tagline: "Awesome. Beer.",
                        firstBrewed: Date(),
                        description: "This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me.",
                        imageURL: imageURL)
        }
    }
}
