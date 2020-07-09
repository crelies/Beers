//
//  BeerCell.swift
//  Beers
//
//  Created by Christian Elies on 07.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerCell: View {
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
        let beer = BeerStore.mock().beers.randomElement()!
        let previewLayout: PreviewLayout = .fixed(
            width: 400,
            height: 50
        )
        let preferredColorScheme: ColorScheme = [.dark, .light].randomElement()!
        return ForEach(0 ..< 5) { item in
            BeerCell(beer: beer)
                .previewLayout(previewLayout)
                .preferredColorScheme(preferredColorScheme)
        }
    }
}
#endif
