//
//  BeerApp.swift
//  Beers
//
//  Created by Christian Elies on 09.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

let dependencies = Dependencies()
let appState = AppState(listState: .init(viewState: .loading, isLoading: false))
let store = Store(
    initialState: appState,
    reducer: AppModule.reducer,
    environment: AppEnvironment(
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
)

@main
struct BeerApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
                .frame(minWidth: 250, minHeight: 700)
        }
    }
}
