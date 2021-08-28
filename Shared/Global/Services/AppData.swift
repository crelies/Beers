//
//  AppData.swift
//  Beers
//
//  Created by Christian Elies on 07.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import Combine
import ComposableArchitecture

final class AppData: ObservableObject {
    private let beerStore: BeerStore = DefaultBeerStore()
    private var appState = AppState(listState: .init(rowStates: [], viewState: .loading, isLoading: false))
    private let reducer: Reducer<AppState, AppAction, AppEnvironment> = AppModule.reducer

    private(set) lazy var store = Store(
        initialState: appState,
        reducer: reducer,
        environment: AppEnvironment(
            fetchBeers: {
                Effect.task {
                    try await self.beerStore.fetchBeers()
                }
                .mapError { BeerListError.underlying($0 as NSError) }
                .eraseToEffect()
            },
            nextBeers: {
                Effect.task {
                    try await self.beerStore.nextBeers()
                }
                .mapError { BeerListError.underlying($0 as NSError) }
                .map { BeersResult(beers: $0, page: self.beerStore.page) }
                .eraseToEffect()
            },
            fetchBeer: { id in
                guard let beer = self.beerStore.beers.first(where: { $0.id == id }) else {
                    return Effect(error: BeerListRowError.beerNotFound)
                }
                return Effect(value: beer)
            },
            moveBeer: { fromOffsets, toOffset in
                self.beerStore.moveBeer(at: fromOffsets, to: toOffset)
                return .none
            },
            deleteBeer: { indexSet in
                self.beerStore.deleteBeer(at: indexSet)
                return .none
            }
        )
    )
}
