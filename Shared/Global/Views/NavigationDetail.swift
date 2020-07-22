//
//  NavigationDetail.swift
//  Beers
//
//  Created by Christian Elies on 22.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import SwiftUI

struct NavigationDetail: View {
    let beer: Beer

    var body: some View {
        BeerDetailScreen(beer: beer)
    }
}

struct NavigationDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationDetail(beer: .mock())
    }
}
