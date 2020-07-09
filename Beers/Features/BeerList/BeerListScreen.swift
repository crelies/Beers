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
                        LazyVStack(alignment: .leading, spacing: 18) {
                            ForEach(beerStore.beers, content: { beer in
                                BeerCell(beer: beer)
                                handleBeer(beer)
                            })
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(16)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Beers")
        }
    }
}

private extension BeerListScreen {
    func handleBeer(_ beer: Beer) -> some View {
        let isLastItem = beerStore.beers.firstIndex(of: beer) == beerStore.beers.endIndex - 1
        if isLastItem && !beerStore.reachedEnd {
            beerStore.nextBeers()
            return AnyView(ProgressView())
        }
        return AnyView(EmptyView())
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
