//
//  BeerAPIService.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Combine
import Foundation

protocol BeerAPIServiceProvider {
    var beerAPIService: BeerAPIServiceProtocol { get }
}

protocol BeerAPIServiceProtocol {
    var publisher: AnyPublisher<[Beer], Error> { get }
}

final class BeerAPIService: BeerAPIServiceProtocol {
    private let url: URL
    private let urlSession: URLSession
    private let urlRequest: URLRequest
    
    let publisher: AnyPublisher<[Beer], Error>
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter
    }()
    
    init() {
        url = URL(string: "https://api.punkapi.com/v2/beers")!
        urlSession = URLSession(configuration: .default)
        urlRequest = URLRequest(url: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(BeerAPIService.formatter)
        
        publisher = urlSession.dataTaskPublisher(for: urlRequest)
            .compactMap { $0.data }
            .decode(type: [Beer].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
