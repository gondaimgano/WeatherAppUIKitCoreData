//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Gondai Mgano on 1/6/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class FavoriteWeatherAnnotation: MKPointAnnotation {
    
    var favorite:Weather? = nil
    
}
class MapViewController: UIViewController {
    
    @IBOutlet weak var mapWeatherView: MKMapView!
    var fetchWeatherRequest:NSFetchRequest<Weather>{
          
             let request:NSFetchRequest<Weather> = Weather.fetchRequest()
           
             return request
         }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialize()
    }
    
    func initialize() {
         
         if let listOfTravelledWeatherLocations =  try? DataController.shared.viewContext.fetch(fetchWeatherRequest){
                           listOfTravelledWeatherLocations.forEach{item in
                               self.mapWeatherView.addAnnotation(self.generateAnnotation(pin: item))
                           }
                       }
            
         }
    func generateAnnotation(pin:Weather)->FavoriteWeatherAnnotation{
           
          let annotation = FavoriteWeatherAnnotation()
         annotation.favorite = pin
         
         annotation.coordinate = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
         annotation.title = pin.main
     
          
         
           return annotation
       }

}

//MARK:- MAPVIEWDELEGATE
extension MapViewController:MKMapViewDelegate{
    
 
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          let reuseId = "pin"
                var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
               
        if let ann = annotation as? FavoriteWeatherAnnotation, let _ = ann.favorite{
            
                if pinView == nil {
                                  pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                                  pinView!.canShowCallout = true
                    
               
                        pinView!.pinTintColor = .red
                    
                                  pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                              } else {
                                  pinView!.annotation = annotation
                              
                
            }
        }
              
           
           return pinView
      }
    
    
}
