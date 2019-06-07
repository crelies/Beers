//
//  BeerStoreDependencies.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

protocol BeerStoreDependenciesProtocol: BeerAPIServiceProvider {
    
}

struct BeerStoreDependencies: BeerStoreDependenciesProtocol {
    let beerAPIService: BeerAPIServiceProtocol
    
    init() {
        beerAPIService = BeerAPIService()
    }
}
