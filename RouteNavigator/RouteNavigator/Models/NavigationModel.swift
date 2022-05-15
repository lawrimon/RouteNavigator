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
    let id: Int64
    
    static func == (lhs: NavigationPoint, rhs: NavigationPoint) -> Bool {
        lhs.id == rhs.id
    }
}

final class NavigationModel {
   
    private var client: BoltClient?

    init() {
        do {
        self.client = try BoltClient(hostname: "3d7caec0.databases.neo4j.io",
                                    port: 7687,
                                    username: "neo4j",
                                    password: "nKtO5Z3vgY2n4Ilw5Bdqb8sPnAOBvqyNaUXAWMbk5n8",
                                    encryption: Encryption.certificateIsSelfSigned)
        } catch {
            print("Failed during connection configuration")
        }
    }
    
    func initNavigationPoints() -> [NavigationPoint]? {
        
        guard let client = self.client else {return nil}
        let query = "Match(n: realInter) RETURN n"
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
                    print("\(index): Id: \((key_value["n"] as! Theo.Node).properties["node_osm_id"]!.intValue()!), Lat: \((key_value["n"] as! Theo.Node).properties["lat"] as! CLLocationDegrees), Lon: \((key_value["n"] as! Theo.Node).properties["lon"] as! CLLocationDegrees)")
                    coordinates.append(NavigationPoint(
                        coordinate: CLLocationCoordinate2D(
                            latitude: (key_value["n"] as! Theo.Node).properties["lat"] as! CLLocationDegrees,
                            longitude: (key_value["n"] as! Theo.Node).properties["lon"] as! CLLocationDegrees),
                        id: ((key_value["n"] as! Theo.Node).properties["node_osm_id"]!.intValue())!))
                }
            }
        }
        return coordinates
    }
    
    func getRoute(start: NavigationPoint, target: NavigationPoint) -> ([NavigationPoint]?, Double?) {
        
        guard let client = self.client else {return (nil, nil)}
        /*let query = "MATCH(start: Intersection {node_osm_id:\(start.id)}) WITH start MATCH (end: Intersection {node_osm_id:\(target.id)}) CALL apoc.algo.dijkstra(start,end, 'ROUTE', 'distance') YIELD path with nodes(path) as nodes WITH apoc.coll.pairsMin(nodes) as pairs UNWIND pairs as p WITH p[0] as a, p[1] as b WITH a,b MATCH(a)-[:NODE]-(awn)-[:NEXT*1..50]-(bwn)-[:NODE]-(b) WITH awn,bwn MATCH path = allShortestPaths( (awn)-[:NEXT*1..50]-(bwn) ) WITH nodes(path) as xwn UNWIND xwn as xosmn MATCH(xosmn)-[:NODE]-(x:OSMNode) RETURN x"*/
        let query = "MATCH(start: Intersection {node_osm_id:\(start.id)}) WITH start MATCH (end: Intersection {node_osm_id:\(target.id)}) CALL apoc.algo.dijkstra(start,end, 'ROUTE', 'distance') YIELD path, weight WITH nodes(path) as nodes,weight WITH weight, apoc.coll.pairsMin(nodes) as pairs UNWIND pairs as p WITH weight, p[0] as a, p[1] as b WITH weight, a,b MATCH(a)-[:NODE]-(awn)-[:NEXT*1..50]-(bwn)-[:NODE]-(b) WITH weight, awn,bwn MATCH path = allShortestPaths( (awn)-[:NEXT*1..50]-(bwn) ) WITH weight, nodes(path) as xwn UNWIND xwn as xosmn MATCH(xosmn)-[:NODE]-(x:OSMNode) RETURN x, weight"
        var route: [NavigationPoint] = []
        var weight: Double = .zero
        
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
                    print("\(index): Id: \((key_value["x"] as! Theo.Node).properties["node_osm_id"]!.intValue()!), Lat: \((key_value["x"] as! Theo.Node).properties["lat"] as! CLLocationDegrees), Lon: \((key_value["x"] as! Theo.Node).properties["lon"] as! CLLocationDegrees)")
                    route.append(NavigationPoint(
                        coordinate: CLLocationCoordinate2D(
                            latitude: (key_value["x"] as! Theo.Node).properties["lat"] as! CLLocationDegrees,
                            longitude: (key_value["x"] as! Theo.Node).properties["lon"] as! CLLocationDegrees),
                        id: ((key_value["x"] as! Theo.Node).properties["node_osm_id"]!.intValue())!))
                }
                print("Weight: \(queryResult.rows.first!["weight"] as! Double)")
                weight = queryResult.rows.first!["weight"] as! Double
            }
        }
        return (route, weight)
    }

}
