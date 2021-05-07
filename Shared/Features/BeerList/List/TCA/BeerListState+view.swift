//
//  BeerListState+view.swift
//  Beers
//
//  Created Christian Elies on 23.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//
//  Template generated by Christian Elies @crelies
//  https://www.christianelies.de
//

extension BeerListState {
    var view: BeerListView.State {
        .init(page: page, viewState: viewState, selection: selection, isLoading: isLoading)
    }
}
