//
//  RouteNavigatorTests.swift
//  RouteNavigatorTests
//
//  Created by Max Kiefer on 15.05.22.
//

import XCTest
@testable import RouteNavigator

class RouteNavigatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetRoute() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let viewModel: NavigationViewModel = NavigationViewModel()
        let model: NavigationModel = NavigationModel()
        var points: [NavigationPoint] = []
        for point in viewModel.navigationPoints {
            points.append(point)
        }
        for i in 0...806 {
            let routeWeight = model.getRoute(start: points[i], target: points[i+1]).1
            print("testGetRoute \(i): Route from \(points[i].id) to \(points[i+1].id) with weight \(routeWeight!)")
            XCTAssertNotNil(routeWeight)
        }
        let routeWeight = model.getRoute(start: points[807], target: points[0]).1
        print("testGetRoute 807: Route from \(points[807].id) to \(points[0].id) with weight \(routeWeight!)")
        XCTAssertNotNil(routeWeight)
        
    }

}
