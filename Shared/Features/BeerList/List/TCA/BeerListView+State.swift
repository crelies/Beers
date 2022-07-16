//
//  BeerListView+State.swift
//  Beers
//
//  Created Christian Elies on 23.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

import IdentifiedCollections

extension BeerListView {
    struct State: Equatable {
        let page: Int
        let viewState: ViewState<IdentifiedArrayOf<BeerListRowState>, BeerListError>
        let isBeerPresented: Bool
        let isLoading: Bool
    }
}