//
//  BeerView.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

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
                AsyncImage(url: imageURL) { phase in
                    if let image = phase.image {
                        Spacer()
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom)
                    } else if let error = phase.error {
                        Text(error.localizedDescription)
                    } else {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(beer.name)
        .animation(.easeIn, value: beer)
    }
}

struct BeerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BeerView(beer: DefaultBeerStore.mock().beers.randomElement()!)
        }
    }
}
