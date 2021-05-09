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
    private let beers: [Beer] = [.mock(), .mock()]
    private lazy var environment = BeerListEnvironment(
        fetchBeers: { Effect(value: self.beers) },
        nextBeers: { Effect(value: .init(beers: [], page: 1)) },
        fetchBeer: { _ in Effect(value: .mock()) },
        moveBeer: { _, _  in Effect(value: ()) },
        deleteBeer: { _ in Effect(value: ()) }
    )

    func testOnAppear() {
        let store = TestStore(
            initialState: BeerListState(rowStates: [], viewState: .loading, isLoading: true),
            reducer: BeerListModule.reducer,
            environment: environment
        )

        store.send(.onAppear)
        store.receive(.fetchBeers)
        store.receive(.fetchBeersResponse(.success(.init(beers: beers, page: 1)))) { state in
            state.isLoading = false
            state.page = 1
            
            let rowStates = self.beers.map { BeerListRowState(beer: $0, detailState: nil) }
            state.rowStates = rowStates
            state.viewState = .loaded(rowStates)
        }
    }

    func testSelectBeer() {
        let beer: Beer = .mock()
        let rowStates: [BeerListRowState] = [.init(beer: beer, detailState: nil)]
        let store = TestStore(
            initialState: BeerListState(
                page: 1,
                rowStates: rowStates,
                viewState: .loaded(rowStates),
                isLoading: false
            ),
            reducer: BeerListModule.reducer,
            environment: environment
        )

        store.send(.selectBeer(beer: beer)) { state in
            state.selection = beer
        }
    }

    func testRefresh() {
        let beer: Beer = .mock()
        let rowStates: [BeerListRowState] = [.init(beer: beer, detailState: nil)]
        let store = TestStore(
            initialState: BeerListState(
                page: 1,
                rowStates: rowStates,
                viewState: .loaded(rowStates),
                isLoading: false
            ),
            reducer: BeerListModule.reducer,
            environment: environment
        )

        store.send(.refresh)
        store.receive(.fetchBeers) { state in
            state.isLoading = true
        }
        store.receive(.fetchBeersResponse(.success(.init(beers: beers, page: 1)))) { state in
            state.isLoading = false

            let rowStates = self.beers.map { BeerListRowState(beer: $0, detailState: nil) }
            state.rowStates = rowStates
            state.viewState = .loaded(rowStates)
        }
    }
}
