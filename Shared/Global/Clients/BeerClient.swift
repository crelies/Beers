//
//  BeerClient.swift
//  Beers
//
//  Created by Christian Elies on 11/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import ComposableArchitecture
import Foundation

struct BeerClient {
    var fetchBeers: () async throws -> [Beer]
    var nextBeers: () async throws -> BeersResult
    var fetchBeer: (_ id: Int) async throws -> Beer
    var moveBeer: (_ fromOffsets: IndexSet, _ toOffset: Int) async -> Void
    var deleteBeer: (_ indexSet: IndexSet) async -> Void
    var deleteBeerWithID: (Int) async -> Void
}

private enum BeerClientKey: DependencyKey {
    static var liveValue = BeerClient.live
}

extension DependencyValues {
    var beerClient: BeerClient {
        get { self[BeerClientKey.self] }
        set { self[BeerClientKey.self] = newValue }
    }
}
