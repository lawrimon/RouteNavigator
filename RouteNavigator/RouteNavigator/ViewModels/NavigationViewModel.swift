//
//  NavigationViewModel.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 06.05.22.
//

import Foundation
import MapKit
import SwiftUI

final class NavigationViewModel: ObservableObject {
        
    private let navigationModel = NavigationModel()
    
    // All navigation points
    var navigationPoints: [NavigationPoint]
    
    // Current navigation point
    @Published var mapLocation: NavigationPoint {
        didSet {
            updateMapRegion(navigationPoint: mapLocation)
        }
    }
    
    // Navigation tuple for route algorithm
    var navigationTuple: (startPoint: NavigationPoint, targetPoint: NavigationPoint) = (NavigationPoint(coordinate: CLLocationCoordinate2D(), id: 0),
                                                                                        NavigationPoint(coordinate: CLLocationCoordinate2D(), id: 0))
    private var startPoint: Bool = true
    @Published var targetPoint: Bool = false
    @Published var navigationText: String = "Start point"
    
    // Navigation route
    var navigationRoute: [CLLocationCoordinate2D] = []
    var navigationLine: MKPolyline = MKPolyline()
    var navigationDistance: Double = .zero
    @Published var navigationStarted: Bool = false
    
    // Current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    
    // Show list of navigation points
    @Published var showNavigationList: Bool = false
    
    init() {
        let navigationPoints = navigationModel.initNavigationPoints()!
        self.navigationPoints = navigationPoints
        self.mapLocation = navigationPoints.first!
        
        self.updateMapRegion(navigationPoint: navigationPoints.first!)
        
    }
    
    private func updateMapRegion(navigationPoint: NavigationPoint) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: navigationPoint.coordinate,
                span: mapSpan)
        }
    }
    
    func toggleNavigationList() {
        withAnimation(.easeInOut) {
            showNavigationList.toggle()
        }
    }
    
    func showNextNavigationPoint(navigationPoint: NavigationPoint) {
        withAnimation(.easeInOut) {
            mapLocation = navigationPoint
            showNavigationList = false
        }
    }
    
    func nextButtonPressed() {
        // Get the current index
        guard let currentIndex = navigationPoints.firstIndex(where: { $0 == mapLocation }) else {return}
        
        // Check if nextIndex is valid
        let nextIndex = currentIndex + 1
        guard navigationPoints.indices.contains(nextIndex) else {
            // nextIndex is NOT valid
            // Restart from 0
            guard let firstNavigationPoint = navigationPoints.first else {return}
            showNextNavigationPoint(navigationPoint: firstNavigationPoint)
            return
        }
        // nextIndex is valid
        let nextNavigationPoint = navigationPoints[nextIndex]
        showNextNavigationPoint(navigationPoint: nextNavigationPoint)
    }
    
    func setPointButtonPressed() {
        // Get current navigation point
        let currentPoint = mapLocation
        if startPoint {
            navigationLine = MKPolyline()
            navigationStarted = false
            updateMapRegion(navigationPoint: currentPoint)
            navigationTuple.startPoint = currentPoint
            startPoint = false
            navigationText = "Target point"
            print("Start: \(navigationTuple.startPoint.id)")
        } else {
            navigationTuple.targetPoint = currentPoint
            targetPoint = true
            print("Target: \(navigationTuple.targetPoint.id)")

        }
        
    }
    
    func navigationButtonPressed() {
        navigationRoute.removeAll()
        let route = navigationModel.getRoute(start: navigationTuple.startPoint, target: navigationTuple.targetPoint)
        let routePoints = route.0!
        navigationDistance = route.1!
        for point in routePoints {
            navigationRoute.append(point.coordinate)
        }
        navigationLine = MKPolyline(coordinates: navigationRoute, count: navigationRoute.count)
        navigationStarted = true
        
        var regionRect = (navigationLine.boundingMapRect)
        let wPadding = regionRect.size.width * 0.25
        let hPadding = regionRect.size.height * 0.25

        //Add padding to the region
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding

        //Center the region on the line
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        
        // Reset actions for new navigation
        navigationText = "Start point"
        startPoint = true
        targetPoint = false
        navigationTuple = (NavigationPoint(coordinate: CLLocationCoordinate2D(), id: 0),
                           NavigationPoint(coordinate: CLLocationCoordinate2D(), id: 0))
        
        // Center the map on the route
        mapRegion = MKCoordinateRegion(regionRect)
        
    }
    
}
