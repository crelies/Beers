//
//  Dependencies.swift
//  Beers
//
//  Created by Christian Elies on 16/07/2022.
//  Copyright © 2022 Christian Elies. All rights reserved.
//

struct Dependencies {
    let beerAPIService: BeerAPIService
    let beerStore: BeerStore

    init() {
        let beerAPIService = DefaultBeerAPIService()
        self.beerAPIService = beerAPIService
        beerStore = DefaultBeerStore(beerApiService: beerAPIService)
    }
}
