//
//  AppReducer.swift
//  Beers
//
//  Created Christian Elies on 24.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import ComposableArchitecture

enum AppModule {}

extension AppModule {
    static var reducer: Reducer<AppState, AppAction, AppEnvironment> {
        Reducer.combine(
            BeerListModule.reducer
                .pullback(
                    state: \.listState,
                    action: /AppAction.beerList,
                    environment: { appEnvironment in
                        BeerListEnvironment(
                            mainQueue: DispatchQueue.main.eraseToAnyScheduler,
                            fetchBeers: appEnvironment.fetchBeers,
                            nextBeers: appEnvironment.nextBeers,
                            fetchBeer: appEnvironment.fetchBeer,
                            moveBeer: appEnvironment.moveBeer,
                            deleteBeer: appEnvironment.deleteBeer,
                            deleteBeerWithID: appEnvironment.deleteBeerWithID
                        )
                    }
                )
            ,
            Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
                switch action {
                case let .beerList(listAction):
                    switch listAction {
                    case let .selectBeer(beer):
                        state.selection = beer
                        return .none
                    default:
                        return .none
                    }
                default:
                    return .none
                }
            }
        )
    }
}
