//
//  MapView.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 12.05.22.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @EnvironmentObject var navigationViewModel: NavigationViewModel
        
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
        
        for annotation in mapView.annotations {
            if (annotation.coordinate.latitude == navigationViewModel.mapLocation.coordinate.latitude &&
                annotation.coordinate.longitude == navigationViewModel.mapLocation.coordinate.longitude) {
                    mapView.selectAnnotation(annotation, animated: false)
            }
        }
        
        for overlay in mapView.overlays {
            if overlay is MKPolyline {
                mapView.removeOverlay(overlay)
            }
        }
        mapView.addOverlay(navigationViewModel.navigationLine)
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
    

