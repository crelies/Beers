//
//  BeerView.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import RemoteImage
import SwiftUI

struct BeerView: View {
    let beer: Beer

    var body: some View {
        VStack(spacing: 16) {
            Text(beer.description)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .font(.body)
                .padding()

            if let firstBrewed = beer.firstBrewed {
                HStack(spacing: 2) {
                    Text("First brewed on:")
                        .foregroundColor(.secondary)
                    Text(firstBrewed, style: .date)
                        .foregroundColor(.primary)
                }.font(.footnote)
            }

            if let imageURL = beer.imageURL {
                RemoteImage(type: .url(imageURL), errorView: { error in
                    Text(error.localizedDescription)
                }, imageView: { image in
                    VStack {
                        Spacer()

                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom)
                    }
                }, loadingView: ProgressView.init)
            }
        }
        .navigationTitle(beer.name)
    }
}

#if DEBUG
struct BeerDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BeerView(beer: BeerStore.mock().beers.randomElement()!)
        }
    }
}
#endif
