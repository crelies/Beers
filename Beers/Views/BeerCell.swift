//
//  BeerCell.swift
//  Beers
//
//  Created by Christian Elies on 07.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerCell : View {
    private let beer: Beer
    
    var body: some View {
        return NavigationButton(destination: BeerDetailView(beer: beer)) {
            VStack(alignment: .leading) {
                Text(beer.name)
                    .font(.body)
                Text(beer.tagline)
                    .font(.caption)
            }
        }
    }
    
    init(beer: Beer) {
        self.beer = beer
    }
}

#if DEBUG
struct BeerCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                BeerCell(beer: MockBeerStore().beers.randomElement()!)
            }
        }
    }
}
#endif
