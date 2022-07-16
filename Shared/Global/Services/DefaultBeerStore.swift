//
//  BeerStore.swift
//  Beers
//
//  Created by Christian Elies on 09.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import Foundation

final class DefaultBeerStore {
    private enum Constants {
        static let pageSize = 25
    }

    private let beerAPIService: BeerAPIService
    private let pageSize = Constants.pageSize
    private var reachedLastPage = false

    // MARK: - Internal

    private(set) var beers: [Beer] = []
    private(set) var page = 1

    init(beerApiService: BeerAPIService = DefaultBeerAPIService()) {
        self.beerAPIService = beerApiService
    }
}

extension DefaultBeerStore: BeerStore {
    func fetchBeers() async throws -> [Beer] {
        page = 1
        reachedLastPage = false
        let beers = try await beerAPIService.getBeers(page: page, pageSize: pageSize)
        self.beers = beers
        return beers
    }

    func nextBeers() async throws -> [Beer] {
        guard !reachedLastPage else {
            return beers
        }
        page += 1
        let beers = try await beerAPIService.getBeers(page: page, pageSize: pageSize)
        self.beers.append(contentsOf: beers)
        self.reachedLastPage = beers.count < self.pageSize
        return self.beers
    }

    func moveBeer(at indexSet: IndexSet, to offset: Int) {
        beers.move(fromOffsets: indexSet, toOffset: offset)
    }

    func deleteBeer(at indexSet: IndexSet) {
        beers.remove(atOffsets: indexSet)
    }

    func deleteBeer(with id: Int) {
        beers.removeAll(where: { $0.id == id })
    }
}

extension DefaultBeerStore {
    static func mock() -> BeerStore {
        let tagline = "Awesome. Beer."
        let firstBrewed = Date()
        let description = "This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me."
        let imageURL = URL(string: "https://images.punkapi.com/v2/8.png")!

        let randomMax = Int.random(in: -1005 ... -1000)
        let store = DefaultBeerStore()
        store.beers = Array(randomMax ... -995).map {
            Beer(
                id: $0,
                name: "Beer No. \($0)",
                tagline: tagline,
                firstBrewed: firstBrewed,
                description: description,
                imageURL: imageURL
            )
        }
        return store
    }
}
