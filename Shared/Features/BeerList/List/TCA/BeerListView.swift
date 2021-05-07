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
    private var listStyle: some ListStyle {
        #if os(macOS)
        return SidebarListStyle()
        #else
        return DefaultListStyle()
        #endif
    }

    let store: Store<BeerListState, BeerListAction>

    var body: some View {
        WithViewStore(
            store.scope(
                state: \.view,
                action: { (viewAction: BeerListView.Action) in
                    viewAction.feature
                }
            )
        ) { viewStore in
            switch viewStore.viewState {
            case .loading:
                ProgressView()
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
            case let .loaded(rowStates):
                List(
                    selection: viewStore.binding(
                        get: { _ in viewStore.selection },
                        send: BeerListView.Action.selectBeer(beer:)
                    )
                ) {
                    if rowStates.isEmpty {
                        Text("No beers").font(.headline)
                    } else {
                        Section(header: headerView(page: viewStore.page), footer: footerView(count: rowStates.count)) {
                            ForEachStore(
                                store.scope(
                                    state: \.rowStates,
                                    action: BeerListAction.row
                                )) { rowViewStore in
                                BeerListRowView(store: rowViewStore)
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
                .padding()
                .listStyle(listStyle)
                .navigationTitle("Beers")
    //            .navigationSubtitle("🍺")
                .toolbar {
                    #if os(iOS)
                    ToolbarItem {
                        EditButton()
                    }
                    #endif
                }
            case let .failed(error):
                Text(error.localizedDescription)
            }
        }
    }
}

private extension BeerListView {
    func headerView(page: Int) -> some View {
        HStack {
            Spacer()

            Text("\(page) page(s) loaded")
            .foregroundColor(.secondary)
            .font(.caption)

            Spacer()
        }
    }

    func footerView(count: Int) -> some View {
        HStack {
            Spacer()

            Text("\(count) beers")
            .foregroundColor(.secondary)
            .font(.footnote)

            Spacer()
        }
    }
}
