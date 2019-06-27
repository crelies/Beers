//
//  BeerImageModel.swift
//  Beers
//
//  Created by Christian Elies on 08.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

final class BeerImageModel: BindableObject {
    private static let urlSession = URLSession.shared
    private let imageURL: URL
    private var subscriber: AnySubscriber<UIImage, URLError>?
    
    private(set) var image: UIImage? = nil {
        didSet {
            didChange.send(()) // BindableObject
        }
    }
    let didChange = PassthroughSubject<Void, Never>() // BindableObject
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        
        let urlRequest = URLRequest(url: imageURL)
        subscriber = BeerImageModel.urlSession.dataTaskPublisher(for: urlRequest)
            .compactMap { $0.data }
            .compactMap { UIImage(data: $0) }
            .sink(receiveValue: { image in
                self.image = image
            })
            .eraseToAnySubscriber()
    }
}
