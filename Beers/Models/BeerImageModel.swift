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

final class BeerImageModel: ObservableObject {
    private static let urlSession = URLSession.shared
    private let imageURL: URL
    private var subscriber: Subscribers.Completion<URLError>?
    private var cancellable: AnyCancellable?
    
    private(set) var image: UIImage? = nil {
        didSet {
            objectWillChange.send(()) // BindableObject
        }
    }
    let objectWillChange = PassthroughSubject<Void, Never>() // BindableObject
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        
        let urlRequest = URLRequest(url: imageURL)
        cancellable = BeerImageModel.urlSession.dataTaskPublisher(for: urlRequest)
            .compactMap { $0.data }
            .compactMap { UIImage(data: $0) }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { subscriber in
                self.subscriber = subscriber
            }, receiveValue: { image in
                self.image = image
            })
    }
}
