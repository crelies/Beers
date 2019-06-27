//
//  BeerDetailView.swift
//  Beers
//
//  Created by Christian Elies on 07.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerDetailView : View {
    private let beer: Beer
    
    var body: some View {
        VStack {
            Section {
                VStack(alignment: .leading) {
                    Text(beer.description)
                        .lineLimit(nil)
                        .font(.body)
                    Text("First brewed on: \(beer.firstBrewed, formatter: BeerAPIService.formatter)")
                        .font(.footnote)
                }.padding(.horizontal)
            }
            
            Section {
                BeerImageView(beerImage: beer.beerImage)
            }
        }
        .navigationBarTitle(Text(beer.name), displayMode: .inline)
    }
    
    init(beer: Beer) {
        self.beer = beer
    }
}

#if DEBUG
struct BeerDetailView_Previews : PreviewProvider {
    static var previews: some View {
        let beer = MockBeerStore().beers.randomElement()!
        
        return NavigationView {
            BeerDetailView(beer: beer)
        }
    }
}
#endif
