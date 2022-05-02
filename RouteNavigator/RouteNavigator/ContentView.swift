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
   
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear{
                viewModel.checkIfLocationServicesIsEnabled()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

