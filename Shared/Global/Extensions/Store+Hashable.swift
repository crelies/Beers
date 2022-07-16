//
//  Store+Hashable.swift
//  Beers
//
//  Created by Christian Elies on 16/07/2022.
//  Copyright © 2022 Christian Elies. All rights reserved.
//

import ComposableArchitecture

extension Store: Hashable where State: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ViewStore(self).state)
    }
}
