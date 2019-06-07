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
    @ObjectBinding private var beer: Beer
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if !zoomed {
                VStack(alignment: .leading, spacing: 8) {
                    Text(beer.name)
                        .font(.title)
                    Text("First brewed on: \(beer.firstBrewed, formatter: BeerAPIService.formatter)")
                        .font(.body)
                    Text(beer.description)
                        .lineLimit(10)
                        .font(.caption)
                }.padding(.horizontal, 50.0)
            }
            
            if beer.image != nil {
                Image(uiImage: beer.image!)
                    .resizable()
                    .aspectRatio(contentMode: zoomed ? .fill : .fit)
                    .tapAction {
                        withAnimation {
                            self.zoomed.toggle()
                        }
                    }
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
