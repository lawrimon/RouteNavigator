//
//  ContentModel.swift
//  RouteNavigator
//
//  Created by Max Kiefer on 02.05.22.
//

import Foundation
import Theo

final class ContentModel: ObservableObject {
    
    let client = try! BoltClient(hostname: "neo4j+s://6e2c8662.databases.neo4j.io",
                                port: 7687,
                                username: "neo4j",
                                password: "A1FB6-JR-I9bPgj9Rj8LkK-ONgGYxcFwn_v6LwJGYW8",
                                encrypted: true)
        
}
