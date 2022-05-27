//
//  RouteNavigatorTests.swift
//  RouteNavigatorTests
//
//  Created by Max Kiefer on 15.05.22.
//

import XCTest
import Theo
@testable import RouteNavigator

class RouteNavigatorTests: XCTestCase {

    func testGetRoute() throws {
        let viewModel: NavigationViewModel = NavigationViewModel()
        let model: NavigationModel = NavigationModel()
        var points: [NavigationPoint] = []
        for point in viewModel.navigationPoints {
            points.append(point)
        }
        for i in 0...806 {
            let routeWeight = model.getRoute(start: points[i], target: points[i+1]).1
            print("testGetRoute [\(i)]: Route from \(points[i].id) to \(points[i+1].id) with weight \(routeWeight!)")
            XCTAssertNotNil(routeWeight)
        }
        let routeWeight = model.getRoute(start: points[807], target: points[0]).1
        print("testGetRoute [807]: Route from \(points[807].id) to \(points[0].id) with weight \(routeWeight!)")
        XCTAssertNotNil(routeWeight)
    }
    
    func testInitNavigationPoints() throws {
        let model: NavigationModel = NavigationModel()
        var points: [NavigationPoint] = []
        points = model.initNavigationPoints()!
        XCTAssertEqual(points.count, 808)
    }
    
    func testNeo4jConnection() throws {
        var test = false
        var client: BoltClient?
        do {
        client = try BoltClient(hostname: "3d7caec0.databases.neo4j.io",
                                    port: 7687,
                                    username: "neo4j",
                                    password: "nKtO5Z3vgY2n4Ilw5Bdqb8sPnAOBvqyNaUXAWMbk5n8",
                                    encryption: Encryption.certificateIsSelfSigned)
        } catch {
            print("testNeo4jConnection: Failed during connection configuration")
        }
        guard let testClient = client else {return}
        let result = testClient.connectSync()
        switch result {
        case .failure(_):
            print("testNeo4jConnection: Error while connecting")
            test = false
        case .success(_):
            print("testNeo4jConnection: Success while connecting")
            test = true
        }
        test = false
        XCTAssertTrue(test)
    }

}
