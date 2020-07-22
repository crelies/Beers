//
//  BeerApp.swift
//  Beers
//
//  Created by Christian Elies on 09.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import SwiftUI

@main
struct BeerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var beerStore = BeerStore()
    @State private var selectedBeer: Beer?

    var body: some Scene {
        WindowGroup {
            NavigationView {
                NavigationPrimary(beerStore: beerStore, selectedBeer: $selectedBeer)

                #if os(macOS)
                if let selectedBeer = selectedBeer {
                    NavigationDetail(beer: selectedBeer)
                }
                #endif
            }
            .onAppear(perform: beerStore.loadBeers)
        }.onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                beerStore.loadBeers()
            }
        }
    }
}
