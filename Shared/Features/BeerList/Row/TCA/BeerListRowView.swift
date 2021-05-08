//
//  BeerListRowView.swift
//  Beers
//
//  Created Christian Elies on 23.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import ComposableArchitecture
import SwiftUI

struct BeerListRowView: View {
    let store: Store<BeerListRowState, BeerListRowAction>

    var body: some View {
        WithViewStore(
            store.scope(
                state: { $0.view },
                action: { (viewAction: BeerListRowView.Action) in
                    viewAction.feature
                }
            )
        ) { viewStore in
            #if os(macOS)
            content(beer: viewStore.beer)
                .tag(viewStore.state.beer)
                .contextMenu {
                    Button(action: {
                        viewStore.send(.delete)
                    }) {
                        Text("Delete")
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            #else
            NavigationLink(
                destination: IfLetStore(
                    store.scope(
                        state: \.detailState,
                        action: BeerListRowAction.beerDetail
                    ),
                    then: BeerDetailView.init(store:),
                    else: { Text("Store not found") }
                ),
                tag: viewStore.beer.id,
                selection: viewStore.binding(
                    get: { $0.detailState?.id },
                    send: BeerListRowView.Action.didTapRow(id:)
                ),
                label: {
                    content(beer: viewStore.beer)
                }
            )
            .onAppear {
                viewStore.send(.onAppear)
            }
            #endif
        }
    }
}

private extension BeerListRowView {
    func content(beer: Beer) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(beer.name)
                .foregroundColor(.primary)
                .font(.title3)
            Text(beer.tagline)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
}
