//
//  BeerListError.swift
//  Beers
//
//  Created by Christian Elies on 24.04.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import Foundation

enum BeerListError: Error, Equatable {
    case underlying(_ error: NSError)
}
