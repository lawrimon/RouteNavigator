//
//  NavigationPreviewView.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 06.05.22.
//

import SwiftUI
import MapKit

struct NavigationPreviewView: View {
    
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    let navigationPoint: NavigationPoint
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                imageSection
                titleSection
            }
            
            
            VStack(spacing: 8) {
                if navigationViewModel.targetPoint {
                    navigationButton
                }
                setPointButton
                nextButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 94)
        )
        .cornerRadius(10)
    }
}

struct NavigationPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            NavigationPreviewView(navigationPoint: NavigationPoint(
                coordinate: CLLocationCoordinate2D(latitude: 48.1454969, longitude: 11.4716758),
            id: 1839359385))
            .padding()
        }
        .environmentObject(NavigationViewModel())
    }
}

extension NavigationPreviewView {
    
    private var imageSection: some View {
        ZStack {
            Image(systemName: "globe")
                .resizable()
                .scaledToFill()
                .foregroundColor(Color.gray)
                .frame(width: 90, height: 90)
                //.cornerRadius(10)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Color.white)
                )
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.black)
            .padding(4)
        )
        .background(Color.white)
        .cornerRadius(10)
}
                    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(verbatim: "\(navigationPoint.id)")
                .font(.system(size: 18))
                .fontWeight(.bold)
            Text("Lat: \(navigationPoint.coordinate.latitude)")
                .font(.subheadline)
            Text("Long: \(navigationPoint.coordinate.longitude)")
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var setPointButton: some View {
        Button {
            navigationViewModel.setPointButtonPressed()
        } label: {
            Text(navigationViewModel.navigationText)
                .font(.headline)
                .frame(width: 125, height: 30)
        }
        .tint(.green)
        .buttonStyle(.borderedProminent)
        .disabled(navigationViewModel.mapLocation == navigationViewModel.navigationTuple.startPoint)
    }
    
    private var nextButton: some View {
        Button {
            navigationViewModel.nextButtonPressed()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 30)
        }
        .buttonStyle(.bordered)
        .foregroundColor(.black)
        
    }
    
    private var navigationButton: some View {
        Button {
            navigationViewModel.navigationButtonPressed()
        } label: {
            Text("Start navigation")
                .font(.headline)
                .frame(width: 125, height: 50)
        }
        .tint(.blue)
        .buttonStyle(.borderedProminent)
        .offset(y: -18)
    }
}
