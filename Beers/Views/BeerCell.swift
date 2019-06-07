//
//  BeerCell.swift
//  Beers
//
//  Created by Christian Elies on 07.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerCell : View {
    private var beer: Beer
    
    var body: some View {
        return NavigationButton(destination: BeerDetailView(beer: beer),
                                onTrigger: onTrigger) {
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

extension BeerCell {
    private func onTrigger() -> Bool {
        beer.requestImage()
        return true
    }
}

#if DEBUG
struct BeerCell_Previews: PreviewProvider {
    static var previews: some View {
        let beer = MockBeerStore().beers.randomElement()!
        return BeerCell(beer: beer)
    }
}
#endif
