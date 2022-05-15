//
//  NavigationListView.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 06.05.22.
//

import SwiftUI

struct NavigationListView: View {
    
    @EnvironmentObject private var navigationViewModel: NavigationViewModel

    var body: some View {
        List {
            ForEach(navigationViewModel.navigationPoints) { navigationPoint in
                Button {
                    navigationViewModel.showNextNavigationPoint(navigationPoint: navigationPoint)
                } label: {
                    listRowView(navigationPoint: navigationPoint)

                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct NavigationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationListView()
            .environmentObject(NavigationViewModel())
    }
}

extension NavigationListView {

    private func listRowView(navigationPoint: NavigationPoint) -> some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .cornerRadius(10)
            VStack (alignment: .leading){
                Text(verbatim: "\(navigationPoint.id)")
                    .font(.headline)
                Text("Lat: \(navigationPoint.coordinate.latitude)")
                    .font(.subheadline)
                Text("Long: \(navigationPoint.coordinate.longitude)")
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

}
