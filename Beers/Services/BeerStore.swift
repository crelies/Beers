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

class BeerStore: BindableObject {
    private let dependencies: BeerStoreDependenciesProtocol
    private var subscriber: AnySubscriber<[Beer], Error>?
    
    var beers: [Beer] = [] {
        didSet {
            didChange.send(())
        }
    }
    let didChange = PassthroughSubject<Void, Never>()
    
    init(dependencies: BeerStoreDependenciesProtocol) {
        self.dependencies = dependencies
        beers = []
        
        subscriber = dependencies.beerAPIService.publisher
            .sink { beers in
                self.beers = beers
            }.eraseToAnySubscriber()
    }
}
