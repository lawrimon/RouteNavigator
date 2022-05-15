//
//  NavigationView.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 06.05.22.
//

import SwiftUI
import MapKit

struct NavigationView: View {
    
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    
    
    var body: some View {
        ZStack {
            //mapLayer
            MapView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .padding(.horizontal)
                if (navigationViewModel.navigationStarted) {
                    distanceText
                }
                Spacer()
                navigationPreviewStack
            }
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
            .environmentObject(NavigationViewModel())
    }
}

extension NavigationView {
    
    private var header: some View {
        VStack {
            Button(action: navigationViewModel.toggleNavigationList) {
                Text(verbatim: "\(navigationViewModel.mapLocation.id)")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: navigationViewModel.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 25))
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: navigationViewModel.showNavigationList ? 180 : 0))
                    }
            }

            if navigationViewModel.showNavigationList {
                NavigationListView()
            }
        }
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        Map(coordinateRegion: .constant(navigationViewModel.mapRegion),
            annotationItems: navigationViewModel.navigationPoints,
            annotationContent: { navigationPoint in
            MapAnnotation(coordinate: navigationPoint.coordinate) {
                NavigationAnnotationView()
                    .scaleEffect(navigationViewModel.mapLocation == navigationPoint ? 0.7 : 0.35)
                    .shadow(radius: 10)
                    .onTapGesture {
                        navigationViewModel.showNextNavigationPoint(navigationPoint: navigationPoint)
                    }
            }
        })
    }
    
    private var distanceText: some View {
        
        Text(verbatim: "Distance: \(Int(navigationViewModel.navigationDistance))m")
            .font(.title2)
            .fontWeight(.black)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: 220)
            .animation(.none, value: navigationViewModel.navigationDistance)
            .background(Color.gray.opacity(0.8))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
            .padding(6)

    }
    
    private var navigationPreviewStack: some View {
        ZStack {
            ForEach(navigationViewModel.navigationPoints) { navigationPoint in
                if navigationViewModel.mapLocation == navigationPoint {
                    NavigationPreviewView(navigationPoint: navigationPoint)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }
}


