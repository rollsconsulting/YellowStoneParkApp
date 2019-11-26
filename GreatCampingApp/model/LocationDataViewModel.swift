//
//  LocationDataViewModelImp.swift
//  GreatCampingApp
//
//  Created by Roland Sarkissian on 11/24/19.
//  Copyright © 2019 Rolls Consulting. All rights reserved.
//

import Foundation
import MapKit


public protocol LocationDataVMDelegate {
    func campSiteData(withName name: String, latitude: Double, and longitute: Double)
}


public protocol LocationDataViewModel {
    var delegate: LocationDataVMDelegate? { get set }
    
    func appendSiteData(withName name: String, latitude: Double, longitude: Double)
    func updateSiteData(with data: GPSLocationData)
    func loadPersistedSiteData() -> ()
    func siteDataContains(location coordinates: CLLocationCoordinate2D) -> Bool
}


class LocationDataViewModelImp: LocationDataViewModel {
    private var campSiteData: [GPSLocationData] = [] {
        didSet {
            
        }
    }
    
    var delegate: LocationDataVMDelegate?
    
    
    private func getURL(_ fileName: String) -> URL? {
        if let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
           let url = dirURL.appendingPathComponent(fileName)
            print("urlPath:\(url.path)")
            return url
        }
        
        return nil
    }
    
    func siteDataContains(location coordinates: CLLocationCoordinate2D) -> Bool {
        let campSite = self.campSiteData.filter {
            $0.coordinates.lat == coordinates.latitude
        }
        
        if campSite.count > 0 {
            return true
        }
        
        return false
    }
    
    
    func appendSiteData(withName name: String, latitude: Double, longitude: Double) {
        let locData = GPSLocationData(nameStr: name, lat: latitude, lon: longitude)
        
        campSiteData.append(locData)
    }
    
    
    func updateSiteData(with data:GPSLocationData) {
        self.campSiteData.append(data)
        
        if !self.campSiteData.isEmpty {
            self.encodeDataToFile(data: self.campSiteData)
        }
    }
    
    
    func loadPersistedSiteData() {
        if let siteData = self.decodeJSONFromFile("parkLocations"), let delegate = delegate {
            for site in siteData {
                delegate.campSiteData(withName: site.name, latitude: site.coordinates.lat, and: site.coordinates.lon)
            }
        }
    }
    
    func decodeJSONFromFile(_ fileName:String) -> [GPSLocationData]? {
        var datafileURL: URL?
        
        var decodedConfig: [GPSLocationData]?
        
        if let fileURL = getURL("CampSiteData.json"), FileManager.default.fileExists(atPath: fileURL.path) {
            datafileURL = fileURL
        } else if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
            datafileURL = fileURL
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let data = try? Data(contentsOf: datafileURL!)
        
        decodedConfig = try?  decoder.decode([GPSLocationData].self, from: data!)
        print(decodedConfig![0].name)
        print(decodedConfig)
        
        return decodedConfig!
    }
    
    
    
    func encodeDataToFile(data: [GPSLocationData]) {
        if let url = getURL("CampSiteData.json") {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(data)
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url)
                }
                if FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil) {
                    print("FileCreated")
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

  
    
    public init() {
      //empty init
    }
}
