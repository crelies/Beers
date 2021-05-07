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

extension BeerListView {
    struct State: Equatable {
        var page: Int
        var viewState: ViewState<[BeerListRowState], BeerListError>
        var selection: Beer?
    }
}