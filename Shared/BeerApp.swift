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
let appState = AppFeature.State(listState: .init(viewState: .loading, isLoading: false))
let store = Store(
    initialState: appState,
    reducer: AppFeature()
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
