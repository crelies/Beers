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

import IdentifiedCollections

struct BeerListState: Equatable {
    var page: Int = 0
    var viewState: ViewState<IdentifiedArrayOf<BeerListRowState>, BeerListError>
    var selection: BeerDetailState?
    var isLoading: Bool
}
