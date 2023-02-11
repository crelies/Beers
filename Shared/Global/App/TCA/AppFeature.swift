//
//  AppFeature.swift
//  Beers
//
//  Created Christian Elies on 24.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import ComposableArchitecture
import Foundation

struct AppFeature: ReducerProtocol {
    struct State: Equatable {
        var listState: BeerListFeature.State
    }

    enum Action: Equatable {
        case onAppear
        case beerList(BeerListFeature.Action)
    }

    var body: some ReducerProtocolOf<Self> {
        Scope(state: \.listState, action: /Action.beerList) {
            BeerListFeature()
        }
    }
}
