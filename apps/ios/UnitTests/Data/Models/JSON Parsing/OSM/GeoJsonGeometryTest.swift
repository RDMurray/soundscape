//
//  GeoJsonGeometryTest.swift
//  
//
//  Created by Kai on 11/7/23.
//

import XCTest
import CoreLocation
import GenericJson
@testable import Soundscape

final class GeoJsonGeometryTest: XCTestCase {

    // GeoJSON strings taken/adapted from the GeoJSON spec, RFC-7946
    private static let pointGeoJson = """
    {
        "type": "Point",
        "coordinates": [100.0, 0.0]
    }
    """

    private static let pointGeometry = GeoJsonGeometry.point(coordinates: CLLocationCoordinate2DMake(0, 100))

    private static let lineStringGeoJson = """
    {
        "type": "LineString",
        "coordinates": [
            [100.0, 0.0],
            [101.0, 1.0]
        ]
    }
    """

    private static let lineStringGeometry = GeoJsonGeometry.lineString(coordinates: [CLLocationCoordinate2DMake(0, 100),
        CLLocationCoordinate2DMake(1, 101)])

    private static let polygonGeoJson = """
    {
        "type": "Polygon",
        "coordinates": [
            [
                [100.0, 0.0],
                [101.0, 0.0],
                [101.0, 1.0],
                [100.0, 1.0],
                [100.0, 0.0]
            ],
            [
                [100.8, 0.8],
                [100.8, 0.2],
                [100.2, 0.2],
                [100.2, 0.8],
                [100.8, 0.8]
            ]
        ]
    }
    """

    private static let polygonGeometry = GeoJsonGeometry.polygon(coordinates: [
        [
            CLLocationCoordinate2DMake(0, 100),
            CLLocationCoordinate2DMake(0, 101),
            CLLocationCoordinate2DMake(1, 101),
            CLLocationCoordinate2DMake(1, 100),
            CLLocationCoordinate2DMake(0, 100)
        ],
        [
            CLLocationCoordinate2DMake(0.8, 100.8),
            CLLocationCoordinate2DMake(0.2, 100.8),
            CLLocationCoordinate2DMake(0.2, 100.2),
            CLLocationCoordinate2DMake(0.8, 100.2),
            CLLocationCoordinate2DMake(0.8, 100.8)
        ]
    ])

    /// normal test case for `GeoJsonGeometry.init(geoJSON: String)`
    func testParseGeoJsonGeometry_Point() throws {
        /// `Point`-- coordinates are a `[Double]`
        let point = GeoJsonGeometry(geoJSON: GeoJsonGeometryTest.pointGeoJson)
        XCTAssertEqual(point, GeoJsonGeometryTest.pointGeometry)
    }

    /// normal test case for `GeoJsonGeometry.encode(to encoder: Encoder)`
    func testEncodeGeoJsonGeometry_point() throws {
        let expectedJSON = try? JSON(JSONSerialization.jsonObject(with: GeoJsonGeometryTest.pointGeoJson.data(using: .utf8)))
        let json = try JSONEncoder().encode(GeoJsonGeometryTest.pointGeometry)
        let actualJSON = try JSON(JSONSerialization.jsonObject(with: json))
        XCTAssertEqual(actualJSON, expectedJSON)
    }
    
    /// normal test case for `GeoJsonGeometry.init(geoJSON: String)`
    func testParseGeoJsonGeometry_LineString() throws {
        /// `LineString`-- coordinates are a `[[Double]]`
        let lineString = GeoJsonGeometry(geoJSON: GeoJsonGeometryTest.lineStringGeoJson)
        XCTAssertEqual(lineString, GeoJsonGeometryTest.lineStringGeometry)
    }

    /// normal test case for `GeoJsonGeometry.encode(to encoder: Encoder)`
    func testEncodeGeoJsonGeometry_LineString() throws {
        let expectedJSON = try? JSON(JSONSerialization.jsonObject(with: GeoJsonGeometryTest.lineStringGeoJson.data(using: .utf8)))
        let json = try JSONEncoder().encode(GeoJsonGeometryTest.lineStringGeometry)
        let actualJSON = try JSON(JSONSerialization.jsonObject(with: json))
        XCTAssertEqual(actualJSON, expectedJSON)
    }

    /// normal test case for `GeoJsonGeometry.init(geoJSON: String)`
    func testParseGeoJsonGeometry_Polygon() throws {
        /// `Polygon`-- coordinates are a `[[[Double]]]`
        let poly = GeoJsonGeometry(geoJSON: GeoJsonGeometryTest.polygonGeoJson)
        XCTAssertEqual(poly, GeoJsonGeometryTest.polygonGeometry)
    }

    /// normal test case for `GeoJsonGeometry.encode(to encoder: Encoder)`
    func testEncodeGeoJsonGeometry_Polygon() throws {
        let expectedJSON = try? JSON(JSONSerialization.jsonObject(with: GeoJsonGeometryTest.polygonGeoJson.data(using: .utf8)))
        let json = try JSONEncoder().encode(GeoJsonGeometryTest.polygonGeometry)
        let actualJSON = try JSON(JSONSerialization.jsonObject(with: json))
        XCTAssertEqual(actualJSON, expectedJSON)
    }
    
    func testParseGeoJsonGeometry_invalidType() throws {
        let a = GeoJsonGeometry(geoJSON: """
{
    "type": "a",
    "coordinates": [100.0, 0.0]
}
""")
        XCTAssertNil(a)
    }
    
    /// edge case for `GeoJsonGeometry.init(geoJSON: String)` with empty input
    /// which should result in `(nil, nil)`
    func testParseGeoJsonGeometry_emptystring() throws {
        XCTAssertNil(GeoJsonGeometry(geoJSON: ""))
    }
    
    /// edge cases for `GeoJsonGeometry.init(geoJSON: String)` with malformed json
    func testParseGeoJsonGeometry_malformed() throws {
        XCTAssertNil(GeoJsonGeometry(geoJSON: "{a: 1}"))
        XCTAssertNil(GeoJsonGeometry(geoJSON: "{\"a\": asdf}"))
    }
    
    /// edge cases for `GeoJsonGeometry.init(geoJSON: String)` with missing keys
    /// which should result in `nil`
    func testParseGeoJsonGeometry_missing() throws {
        let noType = GeoJsonGeometry(geoJSON: """
{"coordinates": [100.0, 0.0]}
""")
        XCTAssertNil(noType)
        
        let noCoords = GeoJsonGeometry(geoJSON: """
{"type": "Point"}
""")
        XCTAssertNil(noCoords)
    }

}
