//
//  BeerListFeature.swift
//  Beers
//
//  Created Christian Elies on 23.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import ComposableArchitecture
import Foundation
import IdentifiedCollections

struct BeerRowsFeature: ReducerProtocol {
    struct State: Equatable {
        var values: IdentifiedArrayOf<BeerListRowFeature.State>
    }

    enum Action: Equatable {
        case row(index: BeerListRowFeature.State.ID, action: BeerListRowFeature.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            return .none
        }
        .forEach(\.values, action: /Action.row) {
            BeerListRowFeature()
        }
    }
}

struct BeersResult: Equatable {
    let beers: [Beer]
    let page: Int
}

struct BeerListFeature: ReducerProtocol {
    struct State: Equatable {
        var page: Int = 0
        var viewState: ViewState<BeerRowsFeature.State, BeerListError>
        var selection: BeerDetailFeature.State?
        var isLoading: Bool
    }

    enum Action: Equatable {
        case onAppear
        case row(index: BeerListRowFeature.State.ID, action: BeerListRowFeature.Action)
        case rows(BeerRowsFeature.Action)
        case fetchBeers
        case fetchBeersResponse(TaskResult<BeersResult>)
        case selectBeer(beer: Beer?)
        case setBeerPresented(isPresented: Bool)
        case beerDetail(BeerDetailFeature.Action)
        case move(indexSet: IndexSet, toOffset: Int)
        case delete(indexSet: IndexSet)
        case refresh
    }

    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.beerClient) var beerClient

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
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
                state.viewState = .loaded(.init(values: .init(uniqueElements: rowStates)))

            case let .fetchBeersResponse(.failure(error)):
                state.isLoading = false
                state.viewState = .failed(BeerListError.underlying(error as NSError))

            case let .row(id, rowAction):
                switch rowAction {
                case .onAppear:
                    guard state.viewState != .loading else {
                        return .none
                    }

                    guard let beerIndex = state.viewState.value?.values.firstIndex(where: { $0.id == id }) else {
                        return .none
                    }

                    let lastIndex = (state.viewState.value?.values ?? []).endIndex - 1
                    guard beerIndex == lastIndex - 5 else {
                        return .none
                    }

                    state.isLoading = true

                    return .task(operation: {
                        await .fetchBeersResponse(TaskResult {
                            try await beerClient.nextBeers()
                        })
                    }, catch: { error in
                        .fetchBeersResponse(.failure(error))
                    })
                    .cancellable(id: BeerListCancelID(), cancelInFlight: true)
                    .receive(on: mainQueue)
                    .eraseToEffect()

                case .delete:
                    state.viewState.value?.values.remove(id: id)
                    return .fireAndForget {
                        try await beerClient.deleteBeerWithID(id)
                    }
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
                state.viewState.value?.values.move(fromOffsets: indexSet, toOffset: toOffset)
                return .fireAndForget {
                    try await beerClient.moveBeer(indexSet, toOffset)
                }

            case let .delete(indexSet):
                indexSet.forEach { state.viewState.value?.values.remove(at: $0) }
                return .fireAndForget {
                    try await beerClient.deleteBeer(indexSet)
                }

            case .fetchBeers:
                state.isLoading = true
                return .task(operation: {
                    await .fetchBeersResponse(TaskResult {
                        let beers = try await beerClient.fetchBeers()
                        return BeersResult(beers: beers, page: 1)
                    })
                }, catch: { error in
                    .fetchBeersResponse(.failure(error))
                })
                .cancellable(id: BeerListCancelID(), cancelInFlight: true)
                .receive(on: mainQueue)
                .eraseToEffect()

            case .refresh:
                return .init(value: .fetchBeers)

            default: ()
            }

            return .none
        }
        .ifLet(\.viewState.value, action: /Action.rows) {
            BeerRowsFeature()
        }
        .ifLet(\.selection, action: /Action.beerDetail) {
            BeerDetailFeature()
        }
    }
}
