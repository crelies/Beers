//
//  BeerListRowView+Action.swift
//  Beers
//
//  Created Christian Elies on 23.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

extension BeerListRowView {
    enum Action: Equatable {
        case onAppear
        case selectBeer(beer: Beer?)
        case delete
    }
}
