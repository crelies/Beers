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
            fetchBeers: { Effect(value: beers) },
            nextBeers: { Effect(value: .init(beers: [], page: 1)) },
            fetchBeer: { id in Effect(value: .mock(id: id)) },
            moveBeer: { _, _  in Effect(value: ()) },
            deleteBeer: { _ in Effect(value: ()) },
            deleteBeerWithID: { _ in Effect(value: ()) }
        )
    }
}

final class BeersTests: XCTestCase {
    private let scheduler = DispatchQueue.immediate
    private let beers: [Beer] = [.mock(), .mock()]

    func testOnAppear() {
        let beerClient: BeerClient = .testing(beers: beers)

        let store = TestStore(
            initialState: BeerListFeature.State(viewState: .loading, isLoading: true),
            reducer: BeerListFeature()
        )

        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.dependencies.beerClient = beerClient

        store.send(.onAppear)

        store.receive(.fetchBeers)

        store.receive(.fetchBeersResponse(.success(.init(beers: beers, page: 1)))) { state in
            state.isLoading = false
            state.page = 1

            let rowStates = self.beers.map { BeerListRowFeature.State(beer: $0) }
            state.viewState = .loaded(.init(uniqueElements: rowStates))
        }
    }

    func testSelectBeer() {
        let beerClient: BeerClient = .testing(beers: beers)
        let beer: Beer = .mock()
        let rowStates: [BeerListRowFeature.State] = [.init(beer: beer)]
        let store = TestStore(
            initialState: BeerListFeature.State(
                page: 1,
                viewState: .loaded(.init(uniqueElements: rowStates)),
                isLoading: false
            ),
            reducer: BeerListFeature()
        )
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.dependencies.beerClient = beerClient

        store.send(.selectBeer(beer: beer)) { state in
            state.selection = .init(beer: beer)
        }
    }

    func testRefresh() {
        let beerClient: BeerClient = .testing(beers: beers)
        let beer: Beer = .mock()
        let rowStates: [BeerListRowFeature.State] = [.init(beer: beer)]
        let store = TestStore(
            initialState: BeerListFeature.State(
                page: 1,
                viewState: .loaded(.init(uniqueElements: rowStates)),
                isLoading: false
            ),
            reducer: BeerListFeature()
        )
        store.dependencies.mainQueue = scheduler.eraseToAnyScheduler()
        store.dependencies.beerClient = beerClient

        store.send(.refresh)

        store.receive(.fetchBeers) { state in
            state.isLoading = true
        }

        store.receive(.fetchBeersResponse(.success(.init(beers: beers, page: 1)))) { state in
            state.isLoading = false

            let rowStates = self.beers.map { BeerListRowFeature.State(beer: $0) }
            state.viewState = .loaded(.init(uniqueElements: rowStates))
        }
    }
}
