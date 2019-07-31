//
//  BeerStore.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class BeerStore: ObservableObject {
    private let dependencies: BeerStoreDependenciesProtocol
    private var subscriber: Subscribers.Completion<Error>?
    private var cancellable: AnyCancellable?
    
    var beers: [Beer] = [] {
        didSet {
            objectWillChange.send(())
        }
    }
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    init(dependencies: BeerStoreDependenciesProtocol) {
        self.dependencies = dependencies
        beers = []
        
        cancellable = dependencies.beerAPIService.publisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { subscriber in
                self.subscriber = subscriber
            }, receiveValue: { beers in
                self.beers = beers
            })
    }
}
