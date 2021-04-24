//
//  BeerApp.swift
//  Beers
//
//  Created by Christian Elies on 09.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@main
struct BeerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var beerStore = BeerStore()

    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppState(listState: .init()),
                    reducer: AppModule.reducer,
                    environment: AppEnvironment(
                        fetchBeers: {
                            beerStore.fetchBeers()
                                .mapError { $0 as! BeerListError }
                                .eraseToEffect()
                        },
                        nextBeers: {
                            beerStore.nextBeers()
                                .mapError { $0 as! BeerListError }
                                .eraseToEffect()
                        },
                        fetchBeer: { id in
                            guard let beer = beerStore.beers.first(where: { $0.id == id }) else {
                                return Effect(error: BeerListRowError.beerNotFound)
                            }
                            return Effect(value: beer)
                        }
                    )
                )
            )
            .frame(minWidth: 250, minHeight: 700)
//            NavigationView {
//                NavigationPrimary(beerStore: beerStore, selectedBeer: $selectedBeer)
//
//                #if os(macOS)
//                if let selectedBeer = selectedBeer {
//                    NavigationDetail(beer: selectedBeer)
//                }
//                #endif
//            }
        }
    }
}
