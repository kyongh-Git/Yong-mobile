//
//  Weather.swift
//  AppCodingChallenge
//
//  Created by YongHwan Kim on 9/14/19.
//  Copyright © 2019 YongHwan Kim. All rights reserved.
//

import Foundation
import CoreLocation

var locationManager = CLLocationManager()
var lastLocation :CLLocation! = nil
var myCityName :String = ""
var currLogitude :Double = 0.0
var currLatitute :Double = 0.0

struct Weather {
    
    enum SerializationError : Error
    {
        case missing (String)
        case invalid (String, Any)
    }
    
    init (json :[String :Any]) throws
    {
        
    }
    
    static func myLocation()
    {
        /*locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()*/
        lastLocation = locationManager.location
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            let locationValue :CLLocationCoordinate2D = locationManager.location!.coordinate
            currLatitute = locationValue.latitude
            currLogitude = locationValue.longitude
        }else{
            print("Terminate the app")
        }
    }
    
    static let URLPath = "https://api.darksky.net/forecast/ebe6873be47715403249604a8a65158f/"
    
    static func forecast(withLocation location : CLLocationCoordinate2D, completion: @escaping ([Weather]) -> ())
    {
        let locationCurr = String(currLatitute) + "," + String(currLogitude)
        let url = URLPath + locationCurr
        let request = URLRequest(url :URL(string :url)!)
        
        let task = URLSession.shared.dataTask(with: request)
        {
            (data: Data?, request: URLResponse?, error: Error?) in
            
            var forecastData: [Weather] = []
            if let data = data
            {
                do
                {
                    if let json = try JSONSerialization.jsonObject(with :data, options :[]) as? [String :Any]
                    {
                        if let dailyWeather = json["daily"] as? [String: Any]
                        {
                            if let dailyData = dailyWeather["data"] as? [[String: Any]]
                            {
                                for d in dailyData
                                {
                                    if let weatherObject = try? Weather(json :d)
                                    {
                                        forecastData.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                }
                completion(forecastData)
            }
        }
        task.resume()
    }
}
