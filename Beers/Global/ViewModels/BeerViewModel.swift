//
//  BeerViewModel.swift
//  Beers
//
//  Created by Christian Elies on 16.08.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct BeerViewModel {
    let beer: Beer
}

extension BeerViewModel: Identifiable {
    var id: ObjectIdentifier {
        beer.id
    }
}

extension BeerViewModel: View {
    var body: some View {
        BeerCell(beer: beer)
    }
}
