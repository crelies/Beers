//
//  BeerApp.swift
//  Beers
//
//  Created by Christian Elies on 09.07.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import SwiftUI

@main
struct BeerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appData = AppData()

    var body: some Scene {
        WindowGroup {
            AppView(store: appData.store)
            .frame(minWidth: 250, minHeight: 700)
        }
    }
}
