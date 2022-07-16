//
//  StyleConstants.swift
//  Beers
//
//  Created by Christian Elies on 16/07/2022.
//  Copyright © 2022 Christian Elies. All rights reserved.
//

import SwiftUI

enum StyleConstants {
    static var listStyle: some ListStyle {
        #if os(macOS)
        return InsetListStyle()
        #else
        return InsetGroupedListStyle()
        #endif
    }

    static var leadingToolbarItemPlacement: ToolbarItemPlacement {
        #if os(macOS)
        return .automatic
        #else
        return .navigationBarLeading
        #endif
    }
}
