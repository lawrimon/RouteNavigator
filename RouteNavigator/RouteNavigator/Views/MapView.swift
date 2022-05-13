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
        initAnnotations(mapView: mapView)
        mapView.delegate = context.coordinator
        
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


class MapViewCoordinator: NSObject, MKMapViewDelegate {
      var mapViewController: MapView

      var selectedAnnotation: MKPointAnnotation?
    
      init(_ control: MapView) {
          self.mapViewController = control
      }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            //Custom View for Annotation
                      let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
                     
                    
                        
                      annotationView.canShowCallout = true
                      annotationView.isEnabled = true
                      //Your custom image icon
                      annotationView.image = UIImage(systemName: "triangle.fill")
        
        
                   // let btn = UIButton(type: .detailDisclosure)
                   //annotationView.rightCalloutAccessoryView = btn
        
                        return annotationView
        
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       //navigationViewModel.mapLocation == navigationPoint ? 0.7 : 0.35)
        self.selectedAnnotation = view.annotation as? MKPointAnnotation
        for navigationPoint in mapViewController.navigationViewModel.navigationPoints {
            if (navigationPoint.coordinate.latitude == selectedAnnotation?.coordinate.latitude && navigationPoint.coordinate.longitude == selectedAnnotation?.coordinate.longitude){
                mapViewController.navigationViewModel.showNextNavigationPoint(navigationPoint: navigationPoint)
            }
        }
        
        print(selectedAnnotation?.coordinate)
        //navigationViewModel.showNextNavigationPoint(navigationPoint: selectedAnnotation)
    }
    
}
