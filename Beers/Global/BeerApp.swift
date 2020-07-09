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
    @StateObject private var beerStore = BeerStore()

    var body: some Scene {
        WindowGroup {
            BeerListScreen(beerStore: beerStore)
                .onAppear(perform: beerStore.loadBeers)
        }
    }
}
