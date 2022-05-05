//
//  ContentView.swift
//  RouteNavigator
//
//  Created by Laurin Tarta on 02.05.22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var model = ContentModel()

    @State private var items: [Coordinate] = []
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: items) { item in
            MapPin(coordinate: item.coordinate)
        }
        .ignoresSafeArea()
        .accentColor(Color(.systemPink))
        .onAppear {
            viewModel.checkIfLocationServicesIsEnabled()
            items = model.queryTest()!
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

