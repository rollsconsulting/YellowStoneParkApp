//
//  LocationDataViewModelImp.swift
//  GreatCampingApp
//
//  Created by Roland Sarkissian on 11/24/19.
//  Copyright © 2019 Rolls Consulting. All rights reserved.
//

import Foundation


public protocol LocationDataViewModel {
    func updateSiteData(with data:[GPSLocationData])
    func getParkData() -> [GPSLocationData]?
}



class LocationDataViewModelImp: LocationDataViewModel {
    private var campSiteData: [GPSLocationData]?
    
    
    private func getURL(_ fileName: String) -> URL? {
        if let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
           let url = dirURL.appendingPathComponent(fileName)
            print("urlPath:\(url.path)")
            return url
        }
        
        return nil
    }
    
    func updateSiteData(with data:[GPSLocationData]) {
        self.campSiteData = data
        
        if let csData = self.campSiteData {
            self.encodeDataToFile(data: csData)
        }
    }
    
    func getParkData() -> [GPSLocationData]? {
        self.campSiteData = self.decodeJSONFromFile("parkLocations")
        
        return campSiteData
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
