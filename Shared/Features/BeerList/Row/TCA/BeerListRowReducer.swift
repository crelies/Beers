//
//  BeerListRowReducer.swift
//  Beers
//
//  Created Christian Elies on 23.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import ComposableArchitecture

enum BeerListRowModule {}

extension BeerListRowModule {
    static var reducer: Reducer<BeerListRowState, BeerListRowAction, BeerListRowEnvironment> {
        Reducer.combine(
            BeerDetailModule.reducer
                .optional()
                .pullback(
                    state: \.detailState,
                    action: /BeerListRowAction.beerDetail,
                    environment: { rowEnvironment in
                        BeerDetailEnvironment(fetchBeer: rowEnvironment.fetchBeer)
                    }
                )
            ,
            Reducer<BeerListRowState, BeerListRowAction, BeerListRowEnvironment> { state, action, environment in
                switch action {
                case let .didTapRow(.some(id)):
                    state.detailState = BeerDetailState(id: id)
                    return .none
                case .didTapRow(id: .none):
                    state.detailState = nil
                    return .none
                default:
                    return .none
                }
            }
        )
    }
}
