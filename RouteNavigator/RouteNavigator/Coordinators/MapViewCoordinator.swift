//
//  MapViewCoordinator.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 13.05.22.
//

import MapKit

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
        annotationView.image = UIImage(systemName: "triangle.fill")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // !!! Implement view.setSelected in PreviewView and ListView von aktueller location
        
        view.scaleUp(duration: 0.2, x: 1.5, y: 1.5)
        let selectedAnnotation = view.annotation
        for navigationPoint in mapViewController.navigationViewModel.navigationPoints {
            if (navigationPoint.coordinate.latitude == selectedAnnotation!.coordinate.latitude &&
                navigationPoint.coordinate.longitude == selectedAnnotation!.coordinate.longitude) {
                mapViewController.navigationViewModel.showNextNavigationPoint(navigationPoint: navigationPoint)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.transform = CGAffineTransform(scaleX: 1, y: 1)

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
