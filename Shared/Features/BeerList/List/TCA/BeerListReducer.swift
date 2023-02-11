//
//  BeerListReducer.swift
//  Beers
//
//  Created Christian Elies on 23.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import ComposableArchitecture

enum BeerListModule {}

extension BeerListModule {
    static var reducer: AnyReducer<BeerListState, BeerListAction, BeerListEnvironment> {
        .combine(
            // TODO:
            AnyReducer(BeerDetailFeature(fetchBeer: { _ in .none }))
                .optional()
                .pullback(
                    state: \.selection,
                    action: /BeerListAction.beerDetail,
                    environment: { $0 }
                )
            ,
            AnyReducer(BeerListRowFeature())
                .forEach(
                    state: \.self,
                    action: .self,
                    environment: { $0 }
                )
                .optional()
                .pullback(
                    state: \.viewState.value,
                    action: /BeerListAction.row,
                    environment: { listEnvironment in
                        listEnvironment
                    }
                )
            ,
            AnyReducer<BeerListState, BeerListAction, BeerListEnvironment> { state, action, environment in
                switch action {
                case .onAppear:
                    guard state.page == 0 else {
                        return .none
                    }
                    return .init(value: .fetchBeers)

                case let .fetchBeersResponse(.success(result)):
                    state.isLoading = false
                    state.page = result.page

                    let rowStates = result.beers.map(BeerListRowFeature.State.init)
                    state.viewState = .loaded(.init(uniqueElements: rowStates))

                case let .fetchBeersResponse(.failure(error)):
                    state.isLoading = false
                    state.viewState = .failed(error)

                case let .row(id, rowAction):
                    switch rowAction {
                    case .onAppear:
                        guard state.viewState != .loading else {
                            return .none
                        }

                        guard let beerIndex = state.viewState.value?.firstIndex(where: { $0.id == id }) else {
                            return .none
                        }

                        let lastIndex = (state.viewState.value ?? []).endIndex - 1
                        guard beerIndex == lastIndex - 5 else {
                            return .none
                        }

                        state.isLoading = true

                        return environment.nextBeers()
                            .receive(on: environment.mainQueue())
                            .catchToEffect(BeerListAction.fetchBeersResponse)
                            .cancellable(id: BeerListCancelID(), cancelInFlight: true)

                    case .delete:
                        state.viewState.value?.remove(id: id)
                        return environment.deleteBeerWithID(id)
                            .fireAndForget()
                    }

                case .setBeerPresented(false):
                    state.selection = nil

                case let .selectBeer(beer):
                    if let beer {
                        state.selection = .init(beer: beer)
                    } else {
                        state.selection = nil
                    }

                case let .move(indexSet, toOffset):
                    state.viewState.value?.move(fromOffsets: indexSet, toOffset: toOffset)
                    return environment.moveBeer(indexSet, toOffset)
                        .fireAndForget()

                case let .delete(indexSet):
                    indexSet.forEach { state.viewState.value?.remove(at: $0) }
                    return environment.deleteBeer(indexSet)
                        .fireAndForget()

                case .fetchBeers:
                    state.isLoading = true
                    return environment.fetchBeers()
                        .receive(on: environment.mainQueue())
                        .map { BeersResult(beers: $0, page: 1) }
                        .catchToEffect(BeerListAction.fetchBeersResponse)
                        .cancellable(id: BeerListCancelID(), cancelInFlight: true)

                case .refresh:
                    return .init(value: .fetchBeers)

                default: ()
                }

                return .none
            }
        )
    }
}
