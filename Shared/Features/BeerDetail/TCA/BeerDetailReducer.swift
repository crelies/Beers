//
//  BeerDetailReducer.swift
//  Beers
//
//  Created Christian Elies on 24.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import ComposableArchitecture

enum BeerDetailModule {}

extension BeerDetailModule {
    static var reducer: AnyReducer<BeerDetailState, BeerDetailAction, BeerDetailEnvironment> {
        AnyReducer<BeerDetailState, BeerDetailAction, BeerDetailEnvironment> { state, action, environment in
            switch action {
            case .onAppear:
                return environment.fetchBeer(state.id)
                    .receive(on: environment.mainQueue())
                    .catchToEffect(BeerDetailAction.fetchBeerResponse)

            case let .fetchBeerResponse(.success(beer)):
                state.beer = beer

            default: ()
            }

            return .none
        }
    }
}
