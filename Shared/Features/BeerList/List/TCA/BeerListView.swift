//
//  BeerListView.swift
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

struct BeerListView: View {
    let store: StoreOf<BeerListFeature>

    var body: some View {
        WithViewStore(
            store.scope(
                state: \.view,
                action: { (viewAction: BeerListView.Action) in
                    viewAction.feature
                }
            ),
            content: content
        )
    }
}

private extension BeerListView {
    @ViewBuilder func content(viewStore: ViewStore<BeerListView.State, BeerListView.Action>) -> some View {
        VStack {
            switch viewStore.viewState {
            case .loading:
                ProgressView()
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
            case .loaded:
                listView(viewStore: viewStore)
            case let .failed(error):
                Text(error.localizedDescription)
            }
        }
        .navigationTitle("Beers")
        .toolbar {
            toolbar(viewStore: viewStore)
        }
    }

    @ToolbarContentBuilder
    func toolbar(
        viewStore: ViewStore<BeerListView.State, BeerListView.Action>
    ) -> some ToolbarContent {
        #if os(iOS)
        ToolbarItem {
            if !viewStore.isLoading {
                EditButton()
            }
        }
        #endif

        ToolbarItem(placement: StyleConstants.leadingToolbarItemPlacement) {
            Button(action: {
                viewStore.send(.refresh)
            }) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }

    func listView(viewStore: ViewStore<BeerListView.State, BeerListView.Action>) -> some View {
        List {
            if viewStore.viewState.value?.values.isEmpty ?? true {
                Text("No beers")
                    .font(.headline)
            } else {
                beersSection(viewStore: viewStore)
            }
        }
        .navigationDestination(
            isPresented: viewStore.binding(
                get: { $0.isBeerPresented },
                send: BeerListView.Action.setBeerPresented
            ),
            destination: {
                IfLetStore(
                    store.scope(
                        state: \.selection,
                        action: BeerListFeature.Action.beerDetail
                    ),
                    then: BeerDetailView.init(store:),
                    else: { Text("Store not found") }
                )
            }
        )
        .refreshable {
            await viewStore.send(.refresh, while: \.isLoading)
        }
        .listStyle(StyleConstants.listStyle)
    }

    @ViewBuilder
    func beersSection(
        viewStore: ViewStore<BeerListView.State, BeerListView.Action>
    ) -> some View {
        if case let ViewState.loaded(rowStates) = viewStore.viewState {
            Section(header: headerView(page: viewStore.page), footer: footerView(count: rowStates.values.count, isLoading: viewStore.isLoading)) {
                ForEachStore(
                    store.scope(
                        state: { _ in rowStates.values },
                        action: BeerListFeature.Action.row
                    )) { rowStore in
                        BeerListRowView(store: rowStore)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewStore.send(.selectBeer(beer: ViewStore(rowStore).beer))
                            }
                }
                .onMove { indexSet, offset in
                    viewStore.send(.move(indexSet: indexSet, toOffset: offset))
                }
                .onDelete { indexSet in
                    viewStore.send(.delete(indexSet: indexSet))
                }
            }
        }
    }

    func headerView(page: Int) -> some View {
        HStack {
            Spacer()

            Text("\(page) page(s) loaded")
                .foregroundColor(.secondary)
                .font(.caption)

            Spacer()
        }
    }

    func footerView(count: Int, isLoading: Bool) -> some View {
        VStack {
            HStack {
                Spacer()

                Text("\(count) beers")
                    .foregroundColor(.secondary)
                    .font(.footnote)

                Spacer()
            }

            if isLoading {
                ProgressView()
            }
        }
        .padding()
    }
}
