//
//  BeerDetailScreen.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import RemoteImage
import SwiftUI

struct BeerDetailScreen: View {
    let beer: Beer

    var body: some View {
        VStack(spacing: 16) {
            Text(beer.description)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .font(.body)
                .padding()

            beer.firstBrewed.map { firstBrewed in
                HStack(spacing: 2) {
                    Text("First brewed on:")
                        .foregroundColor(.secondary)
                    Text(firstBrewed, style: .date)
                        .foregroundColor(.primary)
                }
                    .font(.footnote)
            }

            beer.imageURL.map { imageURL in
                VStack {
                    Spacer()

                    RemoteImage(type: .url(imageURL), errorView: { error in
                        Text(error.localizedDescription)
                    }, imageView: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom)
                    }, loadingView: ProgressView.init)
                }
            }
        }
        .navigationBarTitle(beer.name, displayMode: .inline)
    }
}

#if DEBUG
struct BeerDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BeerDetailScreen(beer: BeerStore.mock().beers.randomElement()!)
        }
    }
}
#endif
