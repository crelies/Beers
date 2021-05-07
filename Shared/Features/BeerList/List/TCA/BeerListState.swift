//
//  BeerListState.swift
//  Beers
//
//  Created Christian Elies on 23.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

struct BeerListState: Equatable {
    var page: Int = 0
    var rowStates: [BeerListRowState]
    var viewState: ViewState<[BeerListRowState], BeerListError>
    var selection: Beer?
}
