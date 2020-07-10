//
//  BeerAPIService.swift
//  Beers
//
//  Created by Christian Elies on 10.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import Combine

protocol BeerAPIService {
    func getBeers(page: Int, pageSize: Int) -> AnyPublisher<[Beer], Error>
}
