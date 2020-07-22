//
//  BeerRow.swift
//  Beers
//
//  Created by Christian Elies on 07.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerRow: View {
    let beer: Beer

    var body: some View {
        Group {
            #if os(macOS)
            content()
            #else
            NavigationLink(destination: BeerDetailScreen(beer: beer), label: content)
            #endif
        }
    }
}

private extension BeerRow {
    func content() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(beer.name)
                .foregroundColor(.primary)
                .font(.title3)
            Text(beer.tagline)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
}

#if DEBUG
struct BeerRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BeerRow(beer: BeerStore.mock().beers.randomElement()!)
                .preferredColorScheme(.dark)

            BeerRow(beer: BeerStore.mock().beers.randomElement()!)
                .preferredColorScheme(.light)
        }.previewLayout(.sizeThatFits)
    }
}
#endif
