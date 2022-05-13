//
//  MapView.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 12.05.22.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @EnvironmentObject public var navigationViewModel: NavigationViewModel
    
    func makeCoordinator() -> MapViewCoordinator{
         MapViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(navigationViewModel.mapRegion, animated: true)
        mapView.delegate = context.coordinator
        mapView.addAnnotations(initAnnotations())
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(navigationViewModel.mapRegion, animated: true)
    }
    
    private func initAnnotations() -> [MKPointAnnotation] {
        var annotations: [MKPointAnnotation] = []
        for point in navigationViewModel.navigationPoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = point.coordinate
            annotations.append(annotation)
        }
        return annotations
    }
    
}
