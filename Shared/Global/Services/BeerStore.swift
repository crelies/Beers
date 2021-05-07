//
//  BeerStore.swift
//  Beers
//
//  Created by Christian Elies on 09.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import Combine
import Foundation

final class BeerStore: ObservableObject {
    private enum Constants {
        static let pageSize = 25
    }

    private let beerAPIService: BeerAPIService
    private let pageSize = Constants.pageSize
    private var reachedLastPage = false

    // MARK: - Internal

    private(set) var beers: [Beer] = []
    var page = 1

    init(beerApiService: BeerAPIService = DefaultBeerAPIService()) {
        self.beerAPIService = beerApiService
    }
}

extension BeerStore {
    func fetchBeers() -> AnyPublisher<[Beer], Error> {
        page = 1
        return beerAPIService.getBeers(page: page, pageSize: pageSize)
            .receive(on: RunLoop.main)
            .map {
                self.beers = $0
                return $0
            }
            .eraseToAnyPublisher()
    }

    func nextBeers() -> AnyPublisher<[Beer], Error> {
        guard !reachedLastPage else {
            return Just(beers)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        page += 1
        return beerAPIService.getBeers(page: page, pageSize: pageSize)
            .receive(on: RunLoop.main)
            .map { beers in
                self.beers.append(contentsOf: beers)
                self.reachedLastPage = beers.count < self.pageSize
            }
            .map { _ in self.beers }
            .eraseToAnyPublisher()
    }

    func moveBeer(at indexSet: IndexSet, to offset: Int) {
        beers.move(fromOffsets: indexSet, toOffset: offset)
    }

    func deleteBeer(at indexSet: IndexSet) {
        beers.remove(atOffsets: indexSet)
    }
}

extension BeerStore {
    static func mock() -> BeerStore {
        let tagline = "Awesome. Beer."
        let firstBrewed = Date()
        let description = "This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me. This Beer will blow away your mind. It's a guarantee. Just trust me."
        let imageURL = URL(string: "https://images.punkapi.com/v2/8.png")!

        let randomMax = Int.random(in: -1005 ... -1000)
        let store = BeerStore()
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
