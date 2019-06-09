//
//  BeerDetailView.swift
//  Beers
//
//  Created by Christian Elies on 07.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerDetailView : View {
    @State private var zoomed: Bool = false
    private let beer: Beer
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Section(header: Text(beer.name).font(.title)) {
                if !zoomed {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First brewed on: \(beer.firstBrewed, formatter: BeerAPIService.formatter)")
                            .font(.body)
                        Text(beer.description)
                            .lineLimit(12)
                            .font(.caption)
                    }.padding(.horizontal, 50.0)
                }
            }
            
            Section {
                BeerImageView(zoomed: $zoomed, beerImage: beer.beerImage)
            }
        }
    }
    
    init(beer: Beer) {
        self.beer = beer
    }
}

#if DEBUG
struct BeerDetailView_Previews : PreviewProvider {
    static var previews: some View {
        let beer = MockBeerStore().beers.randomElement()!
        return BeerDetailView(beer: beer)
    }
}
#endif
