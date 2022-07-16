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

final class BeersTests: XCTestCase {
    private let scheduler = DispatchQueue.immediate
    private let beers: [Beer] = [.mock(), .mock()]
    private lazy var environment = BeerListEnvironment(
        mainQueue: scheduler.eraseToAnyScheduler,
        fetchBeers: { Effect(value: self.beers) },
        nextBeers: { Effect(value: .init(beers: [], page: 1)) },
        fetchBeer: { id in Effect(value: .mock(id: id)) },
        moveBeer: { _, _  in Effect(value: ()) },
        deleteBeer: { _ in Effect(value: ()) }
    )

    func testOnAppear() {
        let store = TestStore(
            initialState: BeerListState(viewState: .loading, isLoading: true),
            reducer: BeerListModule.reducer,
            environment: environment
        )

        store.assert(
            .send(.onAppear),
            .receive(.fetchBeers),
            .receive(.fetchBeersResponse(.success(.init(beers: beers, page: 1)))) { state in
                state.isLoading = false
                state.page = 1

                let rowStates = self.beers.map { BeerListRowState(beer: $0) }
                state.viewState = .loaded(.init(uniqueElements: rowStates))
            }
        )
    }

    func testSelectBeer() {
        let beer: Beer = .mock()
        let rowStates: [BeerListRowState] = [.init(beer: beer)]
        let store = TestStore(
            initialState: BeerListState(
                page: 1,
                viewState: .loaded(.init(uniqueElements: rowStates)),
                isLoading: false
            ),
            reducer: BeerListModule.reducer,
            environment: environment
        )

        store.send(.selectBeer(beer: beer)) { state in
            state.selection = .init(beer: beer)
        }
    }

    func testRefresh() {
        let beer: Beer = .mock()
        let rowStates: [BeerListRowState] = [.init(beer: beer)]
        let store = TestStore(
            initialState: BeerListState(
                page: 1,
                viewState: .loaded(.init(uniqueElements: rowStates)),
                isLoading: false
            ),
            reducer: BeerListModule.reducer,
            environment: environment
        )

        store.assert(
            .send(.refresh),
            .receive(.fetchBeers) { state in
                state.isLoading = true
            },
            .receive(.fetchBeersResponse(.success(.init(beers: beers, page: 1)))) { state in
                state.isLoading = false

                let rowStates = self.beers.map { BeerListRowState(beer: $0) }
                state.viewState = .loaded(.init(uniqueElements: rowStates))
            }
        )
    }
}
