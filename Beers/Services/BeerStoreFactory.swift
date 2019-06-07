//
//  BeerStoreFactory.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

protocol BeerStoreFactoryProtocol {
    static func makeBeerStore() -> BeerStore
}

final class BeerStoreFactory: BeerStoreFactoryProtocol {
    static func makeBeerStore() -> BeerStore {
        let dependencies = BeerStoreDependencies()
        return BeerStore(dependencies: dependencies)
    }
}
