//
//  AppView.swift
//  Beers
//
//  Created Christian Elies on 24.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(
            store.scope(
                state: \.view,
                action: { (viewAction: AppView.Action) in
                    viewAction.feature
                }
            )
        ) { viewStore in
            NavigationStack {
                BeerListView(
                    store: store.scope(
                        state: \.listState,
                        action: AppAction.beerList
                    )
                )

                // Detail
//                #if os(macOS)
//                if let selectedBeer = viewStore.selection {
//                    BeerView(beer: selectedBeer)
//                }
//                #endif
            }
        }
    }
}