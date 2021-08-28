//
//  BeerStore.swift
//  Beers
//
//  Created by Christian Elies on 08.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import Foundation

protocol BeerStore {
    var page: Int { get }
    var beers: [Beer] { get }

    func fetchBeers() async throws -> [Beer]
    func nextBeers() async throws -> [Beer]
    func moveBeer(at indexSet: IndexSet, to offset: Int)
    func deleteBeer(at indexSet: IndexSet)
}
