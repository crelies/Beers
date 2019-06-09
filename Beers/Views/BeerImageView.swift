//
//  BeerImageView.swift
//  Beers
//
//  Created by Christian Elies on 08.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerImageView : View {
    @ObjectBinding private var beerImageMocdel: BeerImageModel
    
    var body: some View {
        Group {
            if beerImageMocdel.image != nil {
                Image(uiImage: beerImageMocdel.image!)
                    .resizable()
                    .aspectRatio(0.25, contentMode: .fit)
            } else {
                Text("No image")
            }
        }
    }
    
    init(beerImage: BeerImageModel) {
        self.beerImageMocdel = beerImage
    }
}

#if DEBUG
struct BeerImage_Previews: PreviewProvider {
    static var previews: some View {
        let beer = MockBeerStore().beers.randomElement()!
        let beerImageModel = BeerImageModel(imageURL: beer.imageURL)
        return BeerImageView(beerImage: beerImageModel)
    }
}
#endif
