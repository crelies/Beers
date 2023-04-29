//
//  BeersTests.swift
//  BeersTests
//
//  Created by Christian Elies on 09.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

@testable import Beers
import ComposableArchitecture
import Foundation
import XCTest

extension BeerClient {
    static func testing(beers: [Beer]) -> Self {
        .init(
            fetchBeers: { beers },
            nextBeers: { .init(beers: [], page: 1) },
            fetchBeer: { id in .mock(id: id) },
            moveBeer: { _, _  in },
            deleteBeer: { _ in },
            deleteBeerWithID: { _ in }
        )
    }
}

@MainActor
final class BeersTests: XCTestCase {
    private let beers: [Beer] = [.mock(), .mock()]

    func testOnAppear() async {
        let beerClient: BeerClient = .testing(beers: beers)

        let store = TestStore(
            initialState: BeerListFeature.State(viewState: .loading, isLoading: true),
            reducer: BeerListFeature()
        )
        store.dependencies.beerClient = beerClient

        await store.send(.onAppear)

        await store.receive(.fetchBeers)

        await store.receive(.fetchBeersResponse(.success(.init(beers: beers, page: 1)))) { state in
            state.isLoading = false
            state.page = 1

            let rowStates = self.beers.map { BeerListRowFeature.State(beer: $0) }
            state.viewState = .loaded(.init(values: .init(uniqueElements: rowStates)))
        }
    }

    func testSelectBeer() async {
        let beerClient: BeerClient = .testing(beers: beers)
        let beer: Beer = .mock()
        let rowStates: [BeerListRowFeature.State] = [.init(beer: beer)]
        let store = TestStore(
            initialState: BeerListFeature.State(
                page: 1,
                viewState: .loaded(.init(values: .init(uniqueElements: rowStates))),
                isLoading: false
            ),
            reducer: BeerListFeature()
        )
        store.dependencies.beerClient = beerClient

        await store.send(.row(index: beer.id, action: .selectBeer(beer: beer))) { state in
            state.selection = .init(beer: beer)
        }
    }

    func testRefresh() async {
        let beerClient: BeerClient = .testing(beers: beers)
        let beer: Beer = .mock()
        let rowStates: [BeerListRowFeature.State] = [.init(beer: beer)]
        let store = TestStore(
            initialState: BeerListFeature.State(
                page: 1,
                viewState: .loaded(.init(values: .init(uniqueElements: rowStates))),
                isLoading: false
            ),
            reducer: BeerListFeature()
        )
        store.dependencies.beerClient = beerClient

        await store.send(.refresh)

        await store.receive(.fetchBeers) { state in
            state.isLoading = true
        }

        await store.receive(.fetchBeersResponse(.success(.init(beers: beers, page: 1)))) { state in
            state.isLoading = false

            let rowStates = self.beers.map { BeerListRowFeature.State(beer: $0) }
            state.viewState = .loaded(.init(values: .init(uniqueElements: rowStates)))
        }
    }
}

