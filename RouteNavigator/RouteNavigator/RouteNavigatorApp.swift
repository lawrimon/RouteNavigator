//
//  RouteNavigatorApp.swift
//  RouteNavigator
//
//  Created by Laurin Tarta on 02.05.22.
//

import SwiftUI

@main
struct RouteNavigatorApp: App {
    
    @StateObject private var navigationViewModel = NavigationViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView()
                .environmentObject(navigationViewModel)
        }
    }
}
