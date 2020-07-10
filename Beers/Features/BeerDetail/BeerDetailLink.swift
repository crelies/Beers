//
//  BeerDetailLink.swift
//  Beers
//
//  Created by Christian Elies on 07.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerDetailLink: View {
    let beer: Beer

    var body: some View {
        NavigationLink(destination: BeerDetailScreen(beer: beer)) {
            VStack(alignment: .leading, spacing: 8) {
                Text(beer.name)
                    .foregroundColor(.primary)
                    .font(.title3)
                Text(beer.tagline)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            Spacer()
        }
    }
}

#if DEBUG
struct BeerCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BeerDetailLink(beer: BeerStore.mock().beers.randomElement()!)
                .preferredColorScheme(.dark)

            BeerDetailLink(beer: BeerStore.mock().beers.randomElement()!)
                .preferredColorScheme(.light)
        }.previewLayout(.sizeThatFits)
    }
}
#endif
