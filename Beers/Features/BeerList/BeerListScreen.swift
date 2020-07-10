//
//  BeerListScreen.swift
//  Beers
//
//  Created by Christian Elies on 09.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerListScreen: View {
    @ObservedObject var beerStore: BeerStore

    var body: some View {
        NavigationView {
            Group {
                if beerStore.beers.isEmpty {
                    Text("No beers").font(.headline)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [.sectionHeaders, .sectionFooters]) {
                            Section(header: headerView(), footer: footerView()) {
                                ForEach(beerStore.beers, content: makeBeerRow)
                                .onMove(perform: onMove)
                                .onDelete(perform: onDelete)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Beers")
            .navigationSubtitle("🍺")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

private extension BeerListScreen {
    func headerView() -> some View {
        HStack {
            Spacer()

            Text("\(beerStore.page) page(s) loaded")
            .foregroundColor(.secondary)
            .font(.caption)

            Spacer()
        }
        .padding(.top)
    }

    func footerView() -> some View {
        HStack {
            Spacer()

            Text("\(beerStore.beers.count) beers")
            .foregroundColor(.secondary)
            .font(.footnote)

            Spacer()
        }
        .padding(.bottom)
    }

    func makeBeerRow(for beer: Beer) -> some View {
        VStack(spacing: 16) {
            BeerDetailLink(beer: beer)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)

            handleBeer(beer)
        }
    }

    func handleBeer(_ beer: Beer) -> some View {
        let isLastItem = beerStore.beers.firstIndex(of: beer) == beerStore.beers.endIndex - 1
        if isLastItem && !beerStore.reachedLastPage {
            beerStore.nextBeers()
            return AnyView(ProgressView())
        }
        return AnyView(EmptyView())
    }

    func onMove(_ indexSet: IndexSet, to offset: Int) {
        beerStore.moveBeer(at: indexSet, to: offset)
    }

    func onDelete(_ indexSet: IndexSet) {
        beerStore.deleteBeer(at: indexSet)
    }
}

#if DEBUG
struct BeerListScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BeerListScreen(beerStore: .mock())
        }
        .preferredColorScheme(.dark)
    }
}
#endif
