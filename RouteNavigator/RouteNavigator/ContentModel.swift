//
//  ContentModel.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 02.05.22.
//

import Foundation
import Theo
import MapKit

final class ContentModel: ObservableObject {
   
    private var client: BoltClient?
    
    private var query = "Match(n: Intersection) RETURN n.lat, n.lon, n.node_osm_id LIMIT 768"
    
    
    func queryTest() -> [CLLocationCoordinate2D]? {
                
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

        var coordinates: [CLLocationCoordinate2D] = []
        
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
                    coordinates.append(CLLocationCoordinate2D(latitude: key_value["n.lat"] as! CLLocationDegrees, longitude: key_value["n.lon"] as! CLLocationDegrees))
                }
            }
        }
        return coordinates
}

}
