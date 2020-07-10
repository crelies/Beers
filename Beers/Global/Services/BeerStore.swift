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

    private let beerAPIService = DefaultBeerAPIService()
    private var anyCancellable: AnyCancellable?

    private var page = 1
    private let pageSize = Constants.pageSize

    @Published private(set) var beers: [Beer] = []

    private(set) var reachedLastPage = false

    func loadBeers() {
        anyCancellable?.cancel()

        beerAPIService.getBeers(page: page, pageSize: pageSize)
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .assign(to: $beers)
    }

    func nextBeers() {
        anyCancellable?.cancel()

        page += 1
        anyCancellable = beerAPIService.getBeers(page: page, pageSize: pageSize)
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .sink(receiveCompletion: { _ in }) { beers in
                self.beers.append(contentsOf: beers)
                self.reachedLastPage = beers.isEmpty
            }
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
