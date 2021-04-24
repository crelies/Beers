//
//  NavigationPrimary.swift
//  Beers
//
//  Created by Christian Elies on 22.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct NavigationPrimary: View {
    @ObservedObject var beerStore: BeerStore
    @Binding var selectedBeer: Beer?

    var body: some View {
        AppView(
            store: Store(
                initialState: AppState(listState: .init()),
                reducer: AppModule.reducer,
                environment: AppEnvironment(
                    fetchBeers: {
                        beerStore.fetchBeers()
                            .mapError { $0 as! BeerListError }
                            .eraseToEffect()
                    },
                    nextBeers: {
                        beerStore.nextBeers()
                            .mapError { $0 as! BeerListError }
                            .eraseToEffect()
                    },
                    fetchBeer: { id in
                        guard let beer = beerStore.beers.first(where: { $0.id == id }) else {
                            return Effect(error: BeerListRowError.beerNotFound)
                        }
                        return Effect(value: beer)
                    }
                )
            )
        )
        .frame(minWidth: 250, minHeight: 700)
    }
}

struct NavigationPrimary_Previews: PreviewProvider {
    static var previews: some View {
        NavigationPrimary(beerStore: .mock(), selectedBeer: .constant(nil))
    }
}
