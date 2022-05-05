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
   
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                    .ignoresSafeArea()
                    .accentColor(Color(.systemPink))
                    .onAppear{
                        viewModel.checkIfLocationServicesIsEnabled()
                }
            Button ("queryTest"){
                model.queryTest()
            }
            .buttonStyle(.bordered)
            .background(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

