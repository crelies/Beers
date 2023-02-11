//
//  BeerListAction.swift
//  Beers
//
//  Created Christian Elies on 23.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import Foundation

struct BeersResult: Equatable {
    let beers: [Beer]
    let page: Int
}

enum BeerListAction: Equatable {
    case onAppear
    case row(index: BeerListRowFeature.State.ID, action: BeerListRowFeature.Action)
    case fetchBeers
    case fetchBeersResponse(Result<BeersResult, BeerListError>)
    case selectBeer(beer: Beer?)
    case setBeerPresented(isPresented: Bool)
    case beerDetail(BeerDetailAction)
    case move(indexSet: IndexSet, toOffset: Int)
    case delete(indexSet: IndexSet)
    case refresh
}
