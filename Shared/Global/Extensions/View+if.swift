//
//  View+if.swift
//  Beers
//
//  Created by Christian Elies on 08.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import SwiftUI

extension View {
    func `if`<IfView: View>(transform: (Self) -> IfView) -> some View {
        transform(self)
    }
}
