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
    
    private(set) var image: UIImage? = nil {
        didSet {
            didChange.send(()) // BindableObject
        }
    }
    let didChange = PassthroughSubject<Void, Never>() // BindableObject
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        
        defer {
            requestImage()
        }
    }
}

extension BeerImageModel {
    private func requestImage() {
        let urlRequest = URLRequest(url: imageURL)
        let task = BeerImageModel.urlSession.dataTask(with: urlRequest) { (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        
        task.resume()
    }
}
