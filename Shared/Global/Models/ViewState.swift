//
//  ViewState.swift
//  Beers
//
//  Created by Christian Elies on 07.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

enum ViewState<V: Equatable, E: Error>: Equatable where E: Equatable {
    case loaded(_ value: V)
    case loading
    case failed(_ error: E)
}
