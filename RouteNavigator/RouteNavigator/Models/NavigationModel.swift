//
//  NavigationModel.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 06.05.22.
//

import Foundation
import MapKit
import Theo

struct NavigationPoint: Identifiable, Equatable {

    let coordinate: CLLocationCoordinate2D
    let id: UInt64
    
    static func == (lhs: NavigationPoint, rhs: NavigationPoint) -> Bool {
        lhs.id == rhs.id
    }
}

final class NavigationModel {
   
    private var client: BoltClient?
    
    private var query = "Match(n: Intersection) RETURN n.lat, n.lon, n.node_osm_id LIMIT 768"
    
    
    func queryTest() -> [NavigationPoint]? {
                
        do {
        self.client = try BoltClient(hostname: "6e2c8662.databases.neo4j.io",
                                    port: 7687,
                                    username: "neo4j",
                                    password: "A1FB6-JR-I9bPgj9Rj8LkK-ONgGYxcFwn_v6LwJGYW8",
                                    encryption: Encryption.certificateIsSelfSigned)
        } catch {
            print("Failed during connection configuration")
        }
        
        guard let client = self.client else {return nil}

        var coordinates: [NavigationPoint] = []
        
        let result = client.connectSync()
        switch result {
        case .failure(_):
          print("Error while connecting")
        case .success(_):
            print("Success while connecting")
            let result = client.executeCypherSync(query)
            switch result {
            case let .failure(error):
                print("Error while query \(error)")
            case let .success(queryResult):
                for (index, key_value) in queryResult.rows.enumerated() {
                    print("\(index): \(key_value)");
                    coordinates.append(NavigationPoint(coordinate: CLLocationCoordinate2D(
                        latitude: key_value["n.lat"] as! CLLocationDegrees,
                        longitude: key_value["n.lon"] as! CLLocationDegrees), id: key_value["n.node_osm_id"] as! UInt64))
                }
            }
        }
        return coordinates
}

}
