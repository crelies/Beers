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
        let beer = MockBeerStore().beers.randomElement()!
        let previewLayout: PreviewLayout = .fixed(width: 400,
                                                  height: 50)
        let preferredColorScheme: ColorScheme = [.dark, .light].randomElement()!
        
        return ForEach(0 ..< 5) { item in
            BeerCell(beer: beer)
                .previewLayout(previewLayout)
                .preferredColorScheme(preferredColorScheme)
        }
    }
}
#endif
