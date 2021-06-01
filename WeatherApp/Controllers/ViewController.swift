//
//  ViewController.swift
//  WeatherApp
//
//  Created by Gondai Mgano on 28/4/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

//MARK:- ENUM TO BE USED FOR OUR DIFFABLEDATASOURCE
enum Section {
    case main
}
//MARK:- ALIAS USED FOR BOTH DIFFABLEDATASOURCE AND SNAPSHOT
typealias ForcastDataSource = UITableViewDiffableDataSource<Section,Forecast>
typealias ForecastSnapshot = NSDiffableDataSourceSnapshot<Section, Forecast>


//MARK:- VIEW CONTROLLER FOR OUR MAIN.STORYBOARD VIEW
class ViewController: UIViewController {
   //MARK:- SETUP VARIABLES
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var todayTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var currentWeatherDescLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    var locationManager: CLLocationManager!
    //MARK:- LAZY LOAD DATASOURCE
    lazy var dataSource = loadDataSource()
    //MARK:- DECLARE CORE DATA FETCHREQUEST FOR FORECASTS
    var fetchForecastRequest:NSFetchRequest<Forecast>{
         
            let request:NSFetchRequest<Forecast> = Forecast.fetchRequest()
            let sortBy = NSSortDescriptor(key: "dt", ascending: true)
            request.sortDescriptors = [sortBy]
            return request
        }
    //MARK:- SETUP PULL TO REFRESH CONTROL
    var refreshControl:UIRefreshControl{
        let i = UIRefreshControl()
        i.attributedTitle = NSAttributedString(string:"Fetching...")
        i.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
        return i
    }
    
   
    //MARK: - CACHE IN DATA LIST
    private  var dataList:[Forecast]? = []
     var previousItem: Forecast?
    //MARK:- SETUP AND LOAD DATASOURCE
    override func viewDidLoad() {
        super.viewDidLoad()
       
        forecastTableView.dataSource = dataSource
        fetchWeatherUpdate()
        forecastTableView.refreshControl = refreshControl
    }
    //MARK:- REFRESH COLLECTION FUNCTION LINKED TO OUR REFRESHCONTROL
    @objc func refreshCollection(refreshControl:UIRefreshControl){
        
        fetchWeatherUpdate()
        refreshControl.endRefreshing()
    }
    
    //MARK: - BUILD DATASOURCE FUNCTION
    func loadDataSource() ->ForcastDataSource{
        let source = ForcastDataSource(tableView: self.forecastTableView){(tableView, indexPath, forecast) ->
                UITableViewCell? in
            let cell  = tableView.dequeueReusableCell(withIdentifier: "forecast_cell", for: indexPath) as? WeatherCell
            
            if let cell = cell{
              
                cell.dayOfTheWeek.text = forecast.dt.toDay()
                cell.temperatureLabel.text = forecast.temp.appendDegree()
                cell.timeOfDayLabel.text = forecast.dt.toTime()
                if let desc=forecast.desc {
                    let item = desc.lowercased()
                    cell.iconView.image = UIImage(named: self.buildWeatherIcon(item))?.withRenderingMode(.alwaysTemplate)
                }
                
            }
          
               return cell
               
        }
        
        return source
        
       }


}



//MARK:- VIEWCONTROLLER EXTENSTION LOCATION MANAGER DELEGATE
extension ViewController:CLLocationManagerDelegate{
    //MARK:- FETCH WEATHER UPDATE FUNCTION
    func fetchWeatherUpdate(){
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    //MARK:- RETRIEVE COORDINATES AND INTERROGATE WEATHER ENDPOINTS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     
        manager.stopUpdatingLocation()
        rebuildDataList()
        if let userLocation = locations.last {
            WeatherService.fetchForecast(lon:userLocation.coordinate.longitude,lat:userLocation.coordinate.latitude,units:.metric  , cnt: 40){
                data, error in
                if let data = data {
                  
                    
                    self.dataList?.forEach{ toDelete in
                        DataController.shared.viewContext.delete(toDelete)
                    }
                    try? DataController.shared.viewContext.save()
                    data.list.forEach{
                        item in
                        let toSave = Forecast(context:DataController.shared.viewContext)
                        toSave.desc = item.weather.first?.weatherDescription
                        toSave.dt = Int64(item.dt)
                        toSave.dtTxt = item.dtTxt
                        toSave.temp = item.main.temp
                        toSave.tempMin = item.main.tempMin
                        toSave.tempMax = item.main.tempMax
                    
                    }
                    if let _ =  try? DataController.shared.viewContext.save(){
                        self.rebuildDataList()
                    }
                    
                }
                
            }
             
             
            WeatherService.fetchCurrentWeather(lon:userLocation.coordinate.longitude,lat:userLocation.coordinate.latitude,units:.metric ){
                 data , error in
                 if let data = data{
                    self.currentWeatherDescLabel.text = data.weather?.first?.main
                    self.currentTempLabel.text = data.main?.temp?.appendDegree()
                    if let temps = data.main,let today = temps.temp, let minTemp = temps.tempMin, let maxTemp = temps.tempMax {
                        self.todayTempLabel.text = "Current \n \(today.appendDegree())"
                                           self.minTempLabel.text = "Min \n \(minTemp.appendDegree())"
                                           self.maxTempLabel.text = "Max \n \(maxTemp.appendDegree())"
                    }
                   
                    self.backgroundImage.image = .init(imageLiteralResourceName: self.buildImageBackgroundLiteral(data))
                    
                    let weatherItem = Weather(context: DataController.shared.viewContext)
                    weatherItem.desc = data.weather?.first?.weatherDescription
                    if let coord = data.coord,let lat = coord.lat,let lon=coord.lon{
                        weatherItem.lat = lat
                        weatherItem.lon = lon
                    }
                    weatherItem.main = data.weather?.first?.main
                    weatherItem.temp = "\(data.main?.temp ?? 0)"
                    weatherItem.tempMax = "\(data.main?.tempMax ?? 0)"
                    weatherItem.tempMin = "\(data.main?.tempMin ?? 0)"
                
                    try? DataController.shared.viewContext.save()
                   
                 }
                 if let error = error {
                   
                    self.currentWeatherDescLabel.text = error.localizedDescription
                    
                 }
                
             }
            
            

            
        
     }
              
}
}


extension ViewController{
    //MARK:- BUILD IMAGE BACKGROUND LITERAL
  func buildImageBackgroundLiteral(_ data: CurrentWeatherResponseModel) -> String {
           if let desc = data.weather?.first?.main?.lowercased() {
               if desc.contains("cloud") {
                  return "sea_cloudy"
               }
               else if desc.contains("rain"){
                  return "sea_rainy"
               }
            
          
           }
    return "sea_sunny"
       }
    //MARK:- BUILD WEATHER ICON
  func buildWeatherIcon(_ item: String) -> String{
    var weatherImage = "clear"
      if item.contains("cloud") {
        weatherImage = "partlysunny"
          
      }
      else if item.contains("rain"){
          weatherImage = "rain"
      }
    
    return weatherImage
  }
    //MARK:- REBUILD/REFRESH THE DATALIST FUNCTION
    func rebuildDataList(){
       if let dataList = try? DataController.shared.viewContext.fetch(fetchForecastRequest)
        {
            self.dataList = dataList
            refreshSnapshot()
        }
    }
    
    //MARK:- REFRESH SNAPSHOT FUNCTION
      func refreshSnapshot(){
          
              var snapshot = ForecastSnapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(dataList!)
           
              dataSource.apply(snapshot, animatingDifferences: true)
        
          
          }

}












