//
//  MapView.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 12.05.22.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(navigationViewModel.mapRegion, animated: true)
        initAnnotations(mapView: mapView)
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(navigationViewModel.mapRegion, animated: true)
    }
    
    private func initAnnotations(mapView: MKMapView) {
        for point in navigationViewModel.navigationPoints {
            let annotation = MKPointAnnotation()
            //annotation.title = String(annotationItem.id)
            annotation.coordinate = point.coordinate
            mapView.addAnnotation(annotation)
        }
    }
}
