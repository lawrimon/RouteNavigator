//
//  MapViewCoordinator.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 13.05.22.
//

import MapKit
import UIKit

class MapViewCoordinator: NSObject, MKMapViewDelegate {
      var mapViewController: MapView
    
      init(_ control: MapView) {
          self.mapViewController = control
      }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Custom View for Annotation
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
        annotationView.canShowCallout = false
        //Your custom image icon
        let image = UIImage(systemName: "triangle.fill")
        annotationView.image = image
        annotationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(systemName: "triangle")
        view.scaleUp(duration: 0.2, x: 1, y: 1)
        let selectedAnnotation = view.annotation
        for navigationPoint in mapViewController.navigationViewModel.navigationPoints {
            if (navigationPoint.coordinate.latitude == selectedAnnotation!.coordinate.latitude &&
                navigationPoint.coordinate.longitude == selectedAnnotation!.coordinate.longitude) {
                mapViewController.navigationViewModel.showNextNavigationPoint(navigationPoint: navigationPoint)
            }
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(systemName: "triangle.fill")
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}

extension MKAnnotationView {
    func scaleUp(duration: TimeInterval, x: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: x, y: y)
        }) { (animationCompleted: Bool) -> Void in }
    }
}


