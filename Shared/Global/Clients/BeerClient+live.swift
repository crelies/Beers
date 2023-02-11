//
//  BeerClient.swift
//  Beers
//
//  Created by Christian Elies on 11/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import Foundation

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
