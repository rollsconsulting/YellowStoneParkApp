//
//  MapViewController.swift
//  GreatCampingApp
//
//  Created by Roland Sarkissian on 11/23/19.
//  Copyright © 2019 Rolls Consulting. All rights reserved.
//

import UIKit
import MapKit


enum parkDataType {
    case campSite
    case camper
    case parkEntrance
}

class ParkAnnotation: MKPointAnnotation {
    var type: parkDataType = .campSite
    var siteDescription: String = ""
    var name: String = ""
    var camperPhoneNumber: String = ""

    
    override init() {
        super.init()
    }
    
    convenience init(type: parkDataType) {
        self.init()
        
        self.type = type
        
    }
}



class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let mapViewAnnotationId = "AnnotationView"
    var camperSimTimer: Timer?
    var siteNames: [String] = []
    var model: JSONParser
    
    var campSiteData: [GPSLocationData] = [] {
        didSet {
            self.model.updateSiteData(with: self.campSiteData)
        }
    }
    
    lazy var campDetaileView: DetailedParkDataView = {
        let sb = UIScreen.main.bounds
        let fWidth:CGFloat = 64
        
        let view = DetailedParkDataView(forType: .camper,
                                withFrame: CGRect(x: sb.minX + fWidth,
                                                  y: sb.minY + fWidth,
                                                  width: sb.size.width - (fWidth * 2),
                                                  height: sb.size.height - sb.size.height/2))
        
        
        view.translatesAutoresizingMaskIntoConstraints = true
        view.isHidden = false
        view.backgroundColor = .white
        
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.model = JSONParserImp()
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(withModel model: JSONParser) {
        self.init(nibName: nil, bundle: nil)
        self.model = model  //model injection
    }
    
    required init?(coder: NSCoder) {
        self.model = JSONParserImp()
        super.init(coder: coder)
    }
    
    func getSiteName() -> String {
        if siteNames.count > 0 {
            return siteNames[Int.random(in: 0...siteNames.count-1)]
        }
        
        return "No Name"
    }
    
    func getCamperName() -> String {
        let camperNames = ["Anthony", "Charley", "Julie", "Mike", "Tony", "Annette", "Roman", "Skylar"]
          return camperNames[Int.random(in: 0...camperNames.count-1)]
    }
      
    func camperProvidedNumber() -> String {
        let camperNum = ["000 111 2222", "000 112 2222", "000 113 2222", "000 114 2222", "000 115 2222", "000 115 2222", "000 115 2222", "000 117 2222"]
          return camperNum[Int.random(in: 0...camperNum.count-1)]
    }
    
    
    func makeAndAddVisibleAnnotation(withCoordinates locCor: CLLocationCoordinate2D, withTitle title: String, andtype type: parkDataType, number: String) {
        
        let annotation = ParkAnnotation(type: type)
        
        annotation.siteDescription = (type == .campSite) ? "YellowStone National Park" : "Camping guest"
        
        annotation.name = title
        
        annotation.camperPhoneNumber = number
        
        annotation.coordinate = locCor
        
        mapView.addAnnotation(annotation)
    }
    
   private func location2D(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
          return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      }
    
    func loadCampSitesAndAnnotation() {
        if let siteData = self.model.getParkData() {
            self.campSiteData.append(contentsOf: siteData)
            
            for site in campSiteData {
                let loc = location2D(latitude: site.coordinates.lat, longitude: site.coordinates.lon)
                makeAndAddVisibleAnnotation(withCoordinates: loc, withTitle: site.name, andtype: .campSite, number: "")
            }
        }
    }
    
    
    func getRandomCoordinates() -> CLLocationCoordinate2D {
        let rLat = Double.random(in: 44.2...44.7)
        let rLon = Double.random(in: 110...(110.9)) * -1
        
        return location2D(latitude: rLat, longitude: rLon)
    }
    
    //defualt lat/lon for YellowStone National park
    func loadParkMap(latitude: CLLocationDegrees = 44.528523, longitude: CLLocationDegrees = -110.412812, title: String = "YellowStone National Park" ) {
        let latDelta: CLLocationDegrees = 1.0
        let lonDelta: CLLocationDegrees = 1.0
        
        let span: MKCoordinateSpan = {
           return MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        }()
        
        let location: CLLocationCoordinate2D = location2D(latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = {
            return MKCoordinateRegion(center: location, span: span)
        }()
        
        mapView.setRegion(region, animated: true)
        
        self.makeAndAddVisibleAnnotation(withCoordinates: location, withTitle: title, andtype: .campSite, number: "")
    }
    
    
    func showDetailedView(annotation: ParkAnnotation) {
        campDetaileView.setParams(withType: annotation.type, title: annotation.siteDescription, name: annotation.name, number: annotation.camperPhoneNumber)
        mapView.addSubview(campDetaileView)
    }
    
    
    @objc func addNewCampsite(grlp: UIGestureRecognizer) {
        if (grlp.state == .ended) {
            let touchPoint = grlp.location(in: self.mapView)
            
            let coordindate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            print("TouchedPoint: \(coordindate.latitude) \(coordindate.longitude)")
            
            let name = getSiteName()
            
            let campSite = GPSLocationData(nameStr: name, lat: coordindate.latitude, lon: coordindate.longitude)
            
            self.campSiteData.append(campSite)
            
            self.makeAndAddVisibleAnnotation(withCoordinates: coordindate, withTitle: name, andtype: .campSite, number: "")
         }
    }
    
    
    func addLongPressGR() {
        let lonPressGesRec = UILongPressGestureRecognizer(target: self, action: #selector(addNewCampsite))
        
        lonPressGesRec.minimumPressDuration = 1.5
        
        mapView.addGestureRecognizer(lonPressGesRec)
    }
    
    @objc func generateRandomCamper() {
        let visitor = getRandomCoordinates()
        makeAndAddVisibleAnnotation(withCoordinates: visitor, withTitle: getCamperName(), andtype: .camper, number: camperProvidedNumber())
    }
    
    func simulateCampers() {
        camperSimTimer = Timer.scheduledTimer(timeInterval: 11.0,
                                              target: self,
                                              selector: #selector(generateRandomCamper),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    func initSiteNames() {
        self.siteNames =  ["Alfa",
               "Bravo",
               "Charlie",
               "Delta",
               "Echo",
               "Foxtrot",
               "Golf",
               "Hotel",
               "India",
               "Juliett",
               "Kilo",
               "Lima",
               "vMike",
               "November",
               "Oscar",
               "Papa",
               "Quebec",
               "Romeo",
               "Sierra",
               "Tango",
               "Uniform",
               "Victor",
               "Whiskey",
               "X-ray",
               "Yankee",
               "Zulu"]
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    
        initSiteNames()
        
        addLongPressGR()
        
        loadParkMap()
        
        loadCampSitesAndAnnotation()
        
        simulateCampers()
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?

        if let annotPoint = annotation as? ParkAnnotation { 
           if let annView = mapView.dequeueReusableAnnotationView(withIdentifier: mapViewAnnotationId) {
                annotationView = annView
            } else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: mapViewAnnotationId)
            }

            annotationView?.image = UIImage(named: annotPoint.type == .camper ? "camper" : "tent")
        }
        
        return annotationView
    }
    
    @objc func buttonClicked(_ sender: UIButton?) {
        if let bView = sender {
            let view = bView.superview
            view?.removeFromSuperview()
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annot = view.annotation as? ParkAnnotation {
            self.showDetailedView(annotation: annot)
        }
    }
}





extension UIView {
    func addConstraints(topAncher: CGFloat = 0.0, leadingAnchor: CGFloat = 0.0, trailingAnchor: CGFloat = 0.0, bottomAnchor: CGFloat = 0.0, refrenceView: UIView) {
        self.topAnchor.constraint(equalTo: refrenceView.topAnchor, constant: topAncher).isActive = true
        self.leadingAnchor.constraint(equalTo: refrenceView.leadingAnchor, constant: leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: refrenceView.trailingAnchor, constant: trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: refrenceView.bottomAnchor, constant: bottomAnchor).isActive = true
        
    }
}
