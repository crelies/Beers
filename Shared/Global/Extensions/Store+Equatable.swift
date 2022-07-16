//
//  Store+Equatable.swift
//  Beers
//
//  Created by Christian Elies on 16/07/2022.
//  Copyright © 2022 Christian Elies. All rights reserved.
//

import ComposableArchitecture

extension Store: Equatable where State: Equatable {
    public static func == (lhs: ComposableArchitecture.Store<State, Action>, rhs: ComposableArchitecture.Store<State, Action>) -> Bool {
        ViewStore(lhs).state == ViewStore(rhs).state
    }
}
