//
//  BeerListView.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerListView : View {
    @ObservedObject private var beerStore: BeerStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(beerStore.beers) { beer in
                    BeerCell(beer: beer)
                }
                .onMove(perform: onMove)
                .onDelete(perform: onDelete)
            }
            .navigationBarTitle(Text("Beers"))
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    init(beerStore: BeerStore) {
        self.beerStore = beerStore
    }
}

extension BeerListView {
    private func onMove(from indexSet: IndexSet, to: Int) {
        indexSet.forEach { index in
            let beer = beerStore.beers[index]
            beerStore.beers.remove(at: index)
            beerStore.beers.insert(beer, at: to)
        }
    }
    
    private func onDelete(at indexSet: IndexSet) {
        indexSet.forEach { index in
            beerStore.beers.remove(at: index)
        }
    }
}

#if DEBUG
struct BeerListView_Previews : PreviewProvider {
    static var previews: some View {
        BeerListView(beerStore: MockBeerStore())
    }
}
#endif
