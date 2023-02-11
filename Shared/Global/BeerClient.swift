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
    var fetchBeers: () -> Effect<[Beer], BeerListError>
    var nextBeers: () -> Effect<BeersResult, BeerListError>
    var fetchBeer: (_ id: Int) -> Effect<Beer, BeerError>
    var moveBeer: (_ fromOffsets: IndexSet, _ toOffset: Int) -> Effect<Void, BeerListError>
    var deleteBeer: (_ indexSet: IndexSet) -> Effect<Void, BeerListError>
    var deleteBeerWithID: (Int) -> Effect<Void, BeerListError>
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
                Effect.task {
                    try await dependencies.beerStore.fetchBeers()
                }
                .mapError { BeerListError.underlying($0 as NSError) }
                .eraseToEffect()
            },
            nextBeers: {
                Effect.task {
                    try await dependencies.beerStore.nextBeers()
                }
                .mapError { BeerListError.underlying($0 as NSError) }
                .map { BeersResult(beers: $0, page: dependencies.beerStore.page) }
                .eraseToEffect()
            },
            fetchBeer: { id in
                guard let beer = dependencies.beerStore.beers.first(where: { $0.id == id }) else {
                    return Effect(error: BeerError.beerNotFound)
                }
                return Effect(value: beer)
            },
            moveBeer: { fromOffsets, toOffset in
                dependencies.beerStore.moveBeer(at: fromOffsets, to: toOffset)
                return .none
            },
            deleteBeer: { indexSet in
                dependencies.beerStore.deleteBeer(at: indexSet)
                return .none
            }, deleteBeerWithID: { id in
                dependencies.beerStore.deleteBeer(with: id)
                return .none
            }
        )
    }
}
