//
//  ContentViewModel.swift
//  RouteNavigator
//
//  Created by Laurin Tarta on 02.05.22.
//


import MapKit

enum MapDetails {
    static let startingLocation =  CLLocationCoordinate2D(latitude: 48.1525175, longitude: 11.4566023)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

}

struct AnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation , span: MapDetails.defaultSpan)
    
    var model = ContentModel()
    var annotationItems: [AnnotationItem] = []

    
    var locationManager: CLLocationManager?
    
    func createAnnotationItems() -> [AnnotationItem] {
        var annotationItems: [AnnotationItem] = []
        for coordinate in model.queryTest()! {
            annotationItems.append(AnnotationItem(coordinate: coordinate))
        }
        return annotationItems
    }
    
    func checkIfLocationServicesIsEnabled() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager ()
            locationManager!.delegate = self
            
        } else {
            print ("Turn location services on")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus {
       //Ask for permission
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("ALERT LOCATION IS RESTRICTED")
        case .denied:
            print("ALERT LOCATION IS DENIED")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
        @unknown default:
            break
        }

    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}
