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
    // BeerListError
    var fetchBeers: () async throws -> [Beer]
    // BeerListError
    var nextBeers: () async throws -> BeersResult
    // BeerError
    var fetchBeer: (_ id: Int) async throws -> Beer
    // BeerListError
    var moveBeer: (_ fromOffsets: IndexSet, _ toOffset: Int) async throws -> Void
    // BeerListError
    var deleteBeer: (_ indexSet: IndexSet) async throws -> Void
    // BeerListError
    var deleteBeerWithID: (Int) async throws -> Void
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

extension BeerClient {
    static var live: Self {
        .init(
            fetchBeers: {
                do {
                    return try await dependencies.beerStore.fetchBeers()
                } catch {
                    throw BeerListError.underlying(error as NSError)
                }
            },
            nextBeers: {
                do {
                    let beers = try await dependencies.beerStore.nextBeers()
                    return BeersResult(beers: beers, page: dependencies.beerStore.page)
                } catch {
                    throw BeerListError.underlying(error as NSError)
                }
            },
            fetchBeer: { id in
                guard let beer = dependencies.beerStore.beers.first(where: { $0.id == id }) else {
                    throw BeerError.beerNotFound
                }
                return beer
            },
            moveBeer: { fromOffsets, toOffset in
                dependencies.beerStore.moveBeer(at: fromOffsets, to: toOffset)
            },
            deleteBeer: { indexSet in
                dependencies.beerStore.deleteBeer(at: indexSet)
            }, deleteBeerWithID: { id in
                dependencies.beerStore.deleteBeer(with: id)
            }
        )
    }
}
