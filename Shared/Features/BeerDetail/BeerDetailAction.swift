//
//  BeerDetailAction.swift
//  Beers
//
//  Created Christian Elies on 24.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

enum BeerDetailAction: Equatable, Hashable {
    case onAppear
    case fetchBeerResponse(Result<Beer, BeerListRowError>)
}
