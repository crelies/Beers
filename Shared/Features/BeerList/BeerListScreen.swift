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
    @Binding var selection: Beer?

    var body: some View {
        VStack {
            if beerStore.beers.isEmpty {
                Text("No beers").font(.headline)
            } else {
                List(selection: $selection) {
                    Section(header: headerView(), footer: footerView()) {
                        ForEach(beerStore.beers, id: \.self, content: makeBeerRow)
                        .onMove(perform: onMove)
                        .onDelete(perform: onDelete)
                    }
                }
                .padding()
                .listStyle(SidebarListStyle())
            }
        }
        .navigationTitle("Beers")
        .navigationSubtitle("🍺")
//        .navigationBarItems(trailing: EditButton())
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
    }

    func footerView() -> some View {
        HStack {
            Spacer()

            Text("\(beerStore.beers.count) beers")
            .foregroundColor(.secondary)
            .font(.footnote)

            Spacer()
        }
    }

    func makeBeerRow(for beer: Beer) -> some View {
        let isLastItem = beerStore.beers.firstIndex(of: beer) == beerStore.beers.endIndex - 1

        return VStack(spacing: 16) {
            BeerRow(beer: beer)
            .padding()

            if isLastItem {
                handleBeer(beer)
            }
        }
    }

    func handleBeer(_ beer: Beer) -> some View {
        let isLastItem = beerStore.beers.firstIndex(of: beer) == beerStore.beers.endIndex - 1
        if isLastItem && !beerStore.reachedLastPage {
            beerStore.nextBeers()
            return AnyView(VStack {
                ProgressView()
                Spacer()
            })
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
            BeerListScreen(beerStore: .mock(), selection: .constant(nil))
        }
        .preferredColorScheme(.dark)
    }
}
#endif
