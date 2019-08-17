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
    func getBeers(page: Int, pageSize: Int) -> AnyPublisher<[Beer], Error>
}

final class BeerAPIService {
    private let beersBaseURL: URL
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter
    }()
    
    init() {
        beersBaseURL = URL(string: "https://api.punkapi.com/v2/beers")!
        urlSession = URLSession(configuration: .default)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(BeerAPIService.formatter)
        jsonDecoder = decoder
    }
}

extension BeerAPIService: BeerAPIServiceProtocol {
    func getBeers(page: Int, pageSize: Int) -> AnyPublisher<[Beer], Error> {
        let urlRequest = makeURLRequest(forPage: page,
                                        pageSize: pageSize)
        return urlSession.dataTaskPublisher(for: urlRequest)
            .compactMap { $0.data }
            .decode(type: [Beer].self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}

extension BeerAPIService {
    private func makeURLRequest(forPage page: Int, pageSize: Int) -> URLRequest {
        let pageQueryItem = URLQueryItem(name: "page",
                                         value: "\(page)")
        let pageSizeQueryItem = URLQueryItem(name: "per_page",
                                             value: "\(pageSize)")
        var urlComponents = URLComponents(url: beersBaseURL,
                                          resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [pageQueryItem, pageSizeQueryItem]
        
        if let urlComponentsURL = urlComponents?.url {
            return URLRequest(url: urlComponentsURL)
        } else {
            return URLRequest(url: beersBaseURL)
        }
    }
}
