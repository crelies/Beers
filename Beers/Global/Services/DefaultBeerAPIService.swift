//
//  DefaultBeerAPIService.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Combine
import Foundation

protocol BeerAPIService {
    func getBeers(page: Int, pageSize: Int) -> AnyPublisher<[Beer], Error>
}

final class DefaultBeerAPIService {
    private enum Constants {
        static let baseURL = URL(string: "https://api.punkapi.com/v2/beers")!
        static let dateFormat = "MM/yyyy"
    }

    private let beersBaseURL = Constants.baseURL
    private let urlSession: URLSession = .init(configuration: .default)
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DefaultBeerAPIService.formatter)
        return decoder
    }()

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        return formatter
    }()
}

extension DefaultBeerAPIService: BeerAPIService {
    func getBeers(page: Int, pageSize: Int) -> AnyPublisher<[Beer], Error> {
        let urlRequest = makeURLRequest(
            forPage: page,
            pageSize: pageSize
        )
        return urlSession.dataTaskPublisher(for: urlRequest)
            .compactMap { $0.data }
            .decode(type: [Beer].self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
}

private extension DefaultBeerAPIService {
    func makeURLRequest(forPage page: Int, pageSize: Int) -> URLRequest {
        let pageQueryItem = URLQueryItem(
            name: "page",
            value: "\(page)"
        )

        let pageSizeQueryItem = URLQueryItem(
            name: "per_page",
            value: "\(pageSize)"
        )

        var urlComponents = URLComponents(
            url: beersBaseURL,
            resolvingAgainstBaseURL: false
        )
        urlComponents?.queryItems = [pageQueryItem, pageSizeQueryItem]

        if let urlComponentsURL = urlComponents?.url {
            return URLRequest(url: urlComponentsURL)
        } else {
            return URLRequest(url: beersBaseURL)
        }
    }
}
