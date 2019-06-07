//
//  Beer.swift
//  Beers
//
//  Created by Christian Elies on 06.06.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Combine
import SwiftUI

final class Beer: Identifiable, BindableObject {
    private static let urlSession = URLSession.shared
    
    let id: Int // Identifiable
    let name: String
    let tagline: String
    let firstBrewed: Date
    let description: String
    let imageURL: URL
    
    private(set) var image: UIImage? = nil {
        didSet {
            didChange.send(()) // BindableObject
        }
    }
    private(set) var didChange = PassthroughSubject<Void, Never>() // BindableObject
    
    init(id: Int,
         name: String,
         tagline: String,
         firstBrewed: Date,
         description: String,
         imageURL: URL) {
        self.id = id
        self.name = name
        self.tagline = tagline
        self.firstBrewed = firstBrewed
        self.description = description
        self.imageURL = imageURL
    }
}

extension Beer: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case tagline
        case firstBrewed = "first_brewed"
        case description
        case imageURL = "image_url"
    }
}

extension Beer {
    func requestImage() {
        let urlRequest = URLRequest(url: imageURL)
        let task = Beer.urlSession.dataTask(with: urlRequest) { (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        task.resume()
    }
}
