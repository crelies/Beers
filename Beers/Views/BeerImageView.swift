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
    private var zoomed: Binding<Bool>
    
    var body: some View {
        Group {
            if beerImageMocdel.image != nil {
                Image(uiImage: beerImageMocdel.image!)
                    .resizable()
                    .aspectRatio(contentMode: zoomed.value ? .fill : .fit)
                    .tapAction {
                        withAnimation {
                            self.zoomed.value.toggle()
                        }
                    }
            } else {
                Text("No image")
            }
        }
    }
    
    init(zoomed: Binding<Bool>, beerImage: BeerImageModel) {
        self.zoomed = zoomed
        self.beerImageMocdel = beerImage
    }
    
    #if DEBUG
    init(imageURL: URL) {
        self.zoomed = Binding<Bool>(getValue: { () -> Bool in
            return false
        }, setValue: { value in
            
        })
        self.beerImageMocdel = BeerImageModel(imageURL: imageURL)
    }
    #endif
}

#if DEBUG
struct BeerImage_Previews: PreviewProvider {
    static var previews: some View {
        let beer = MockBeerStore().beers.randomElement()!
        return BeerImageView(imageURL: beer.imageURL)
    }
}
#endif
