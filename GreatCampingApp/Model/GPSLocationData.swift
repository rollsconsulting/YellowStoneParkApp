//
//  GPSLocationData.swift
//  GreatCampingApp
//
//  Created by Roland Sarkissian on 11/23/19.
//  Copyright © 2019 Rolls Consulting. All rights reserved.
//

import Foundation

protocol LocationData {
    var name: String { get set }
    var coordinates: GPSCoordinate { get set }
}


struct GPSLocationData: Codable, LocationData {
    var name: String
    var coordinates: GPSCoordinate
    
    init(nameStr: String, lat: Double, lon: Double) {
        name = nameStr
        coordinates = GPSCoordinate(latitude: lat, longitude: lon)
    }

}

struct GPSCoordinate: Codable {
    var lat: Double
    var lon: Double
    
    init(latitude: Double, longitude: Double) {
        lat = latitude
        lon = longitude
    }
}

