//
//  BeerRowsFeature.swift
//  Beers
//
//  Created by Christian Elies on 11/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import ComposableArchitecture

struct BeerRowsFeature: ReducerProtocol {
    struct State: Equatable {
        var values: IdentifiedArrayOf<BeerListRowFeature.State>
    }

    enum Action: Equatable {
        case row(index: BeerListRowFeature.State.ID, action: BeerListRowFeature.Action)
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            return .none
        }
        .forEach(\.values, action: /Action.row) {
            BeerListRowFeature()
        }
    }
}
