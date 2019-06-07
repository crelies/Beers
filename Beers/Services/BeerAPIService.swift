//
//  BeerAPIService.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

protocol BeerAPIServiceProvider {
    var beerAPIService: BeerAPIServiceProtocol { get }
}

protocol BeerAPIServiceProtocol {
    func getBeers(_ completion: @escaping ([Beer]) -> Void)
}

final class BeerAPIService {
    private let url: URL
    private let urlSession: URLSession
    private let urlRequest: URLRequest
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter
    }()
    
    init() {
        url = URL(string: "https://api.punkapi.com/v2/beers")!
        urlSession = URLSession(configuration: .default)
        urlRequest = URLRequest(url: url)
    }
}

extension BeerAPIService: BeerAPIServiceProtocol {
    func getBeers(_ completion: @escaping ([Beer]) -> Void) {
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(BeerAPIService.formatter)
                
                let beers = try? decoder.decode([Beer].self, from: data)
                
                DispatchQueue.main.async {
                    completion(beers ?? [])
                }
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
        
        task.resume()
    }
}
