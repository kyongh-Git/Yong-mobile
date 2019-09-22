//
//  ViewController.swift
//  AppCodingChallenge
//
//  Created by YongHwan Kim on 9/14/19.
//  Copyright © 2019 YongHwan Kim. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var todayWeather: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var cityNameUpdateLabel: UILabel!
    @IBOutlet weak var cityNameUpdateTextField: UITextField!
    @IBOutlet weak var searchbarTest: UISearchBar!
    
    var isFah :Bool = true
    var firstChecker :Bool = true
    var todaySummary :String = ""
    var firstHigh :String = ""
    var firstLow :String = ""
    var secondHigh :String = ""
    var secondLow :String = ""
    var ThirdHigh :String = ""
    var ThirdLow  :String = ""
    var timer = Timer()
    var seconds = 60
    var todayTemp : String = ""
    var todayIcon : String = ""
    var currTemperature : String = ""
    var iconText : String = ""
    var cityName :String = ""
    var currWeather = [Weather]()
    let URLPath = "https://api.darksky.net/forecast/ebe6873be47715403249604a8a65158f/"
    
    @IBOutlet weak var todayTempLabel: UILabel!
    @IBOutlet weak var todaySummaryLabel: UILabel!
    
    @IBOutlet weak var dayOneHighTempLabel: UILabel!
    @IBOutlet weak var dayOneLowTempLabel: UILabel!
    @IBOutlet weak var dayTwoHighTempLabel: UILabel!
    @IBOutlet weak var dayTwoLowTempLabel: UILabel!
    @IBOutlet weak var dayThreeHighTempLabel: UILabel!
    @IBOutlet weak var dayThreeLowTempLabel: UILabel!
    
    @IBOutlet weak var dayNow: UILabel!
    @IBOutlet weak var dateNow: UILabel!
    @IBOutlet weak var dateFirst: UILabel!
    @IBOutlet weak var dateSecond: UILabel!
    @IBOutlet weak var dateThird: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cityNameUpdateTextField.delegate = self
        cityNameUpdateTextField.isHidden = true
        //var location = CLLocationCoordinate2D
        updateAllGadget()
        timeChecker()
        runTimer()
        date()
    }
    
  
    @IBAction func cityNameUpdateGesture(_ sender: UITapGestureRecognizer) {
        if cityNameUpdateTextField.isHidden == true{
            cityNameUpdateTextField.isHidden = false
        }
    }
    
    // textfield return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityNameUpdateTextField.isHidden = true
        //print("city name is ", cityName)
        cityName = cityNameUpdateTextField.text!
        //print("city name is ", cityName)
        updateAllGadget()
        cityNameUpdateTextField.resignFirstResponder()
        //cityName = cityNameUpdateTextField.text!
        return true
    }
    
    //city temperature gesture
    @IBAction func CTempGesture(_ sender: UITapGestureRecognizer) {
        if isFah{
            frenToCel()
            isFah = false
        }
        else{
            self.dayOneHighTempLabel.text = self.firstHigh + " °F"
            self.dayOneLowTempLabel.text = self.firstLow + " °F"
            self.dayTwoHighTempLabel.text = self.secondHigh + " °F"
            self.dayTwoLowTempLabel.text = self.secondLow + " °F"
            self.dayThreeHighTempLabel.text = self.ThirdHigh + " °F"
            self.dayThreeLowTempLabel.text = self.ThirdLow + " °F"
            self.currentTempLabel.text? = self.currTemperature + " °F"
            self.todayTempLabel.text = self.todayTemp + " °F"
            isFah = true
        }
        
        
    }
    
    // updating every weather data
    func updateAllGadget(){
        // check is this first time or not
        if(firstChecker){
            //print("true")
            weatherUpdate(locationName:"Stillwater")
            cityNameUpdateLabel.text = "Stillwater"
            firstChecker = false
        }
        else{
            weatherUpdate(locationName: cityName)
            cityNameUpdateLabel.text = cityName
        }
    }
    // change frenheight to celcius
    func frenToCel(){
        let firstH = (Int(firstHigh)!-32)*5/9
        let firstL = (Int(firstLow)!-32)*5/9
        let secondH = (Int(secondHigh)!-32)*5/9
        let secondL = (Int(secondLow)!-32)*5/9
        let thirdH = (Int(ThirdHigh)!-32)*5/9
        let thirdL = (Int(ThirdLow)!-32)*5/9
        let todayT = (Int(todayTemp)!-32)*5/9
        let currTemp = (Int(currTemperature)!-32)*5/9
        
        self.dayOneHighTempLabel.text = String(firstH) + " °C"
        self.dayOneLowTempLabel.text = String(firstL) + " °C"
        self.dayTwoHighTempLabel.text = String(secondH) + " °C"
        self.dayTwoLowTempLabel.text = String(secondL) + " °C"
        self.dayThreeHighTempLabel.text = String(thirdH) + " °C"
        self.dayThreeLowTempLabel.text = String(thirdL) + " °C"
     
        self.todayTempLabel.text = String(todayT) + " °C"
        self.currentTempLabel.text = String(currTemp) + " °C"
        
    }
    // change city name to coordinate
    func weatherUpdate(locationName: String){
        CLGeocoder().geocodeAddressString(locationName) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error == nil
            {
                if let location = placemarks?.first?.location
                {
                    self.currentForecastUpdate(withLocation: location.coordinate)
                    
                    self.hourlyForecastUpdate(withLocation: location.coordinate)
                    
                    self.dailyForecastUpdate(withLocation: location.coordinate)
                }
            }
        }
    }
    // get current weather forecast
    func currentForecastUpdate(withLocation location : CLLocationCoordinate2D){
        let fullPath = URLPath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest (url: URL(string: fullPath)!)
        let task = URLSession.shared.dataTask(with: request)
            {
                (data: Data?, request: URLResponse?, error: Error?) in
                if error == nil
                {
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : Any]

                        if let currently = json["currently"] as? [String : Any] {
                            
                            if let currTemper = currently["temperature"] as? Double{
                                self.currTemperature = String(Int(currTemper))
                            }
                            DispatchQueue.main.async
                            {
                                    self.currentTempLabel.text? = self.currTemperature + " °F"
                            }
                        }
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
    }
    // get hourly weather forecast
    func hourlyForecastUpdate(withLocation location : CLLocationCoordinate2D){
        let fullPath = URLPath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest (url: URL(string: fullPath)!)
        let task = URLSession.shared.dataTask(with: request){
            (data: Data?, request: URLResponse?, error: Error?) in
            if error == nil
            {
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let hourly = json["hourly"] as? [String : Any],
                    let data = hourly["data"] as? [[String : Any]],
 
                    let todayTemper = data[14]["temperature"] as? Double {
                    self.todayTemp = String(Int(todayTemper))
                    
                    let summary = data[14]["summary"] as? String
                    self.todaySummary = summary!
                   
                    let icon = data[14]["icon"] as? String
                    self.todayIcon = icon!
                    }
                }
                
                catch let jsonError
                {
                    print(jsonError.localizedDescription)
                }
                // update summary label, icon, temperature
                DispatchQueue.main.async
                {
                    self.todaySummaryLabel.text = self.todaySummary
                    self.weatherIconImage.image = IconView.drawIcon(iconType: self.todayIcon)
                    self.todayTempLabel.text = self.todayTemp + " °F"
                    
                }
            }
        }
        task.resume()
    }
    // get daily forecast -> three days after current
    func dailyForecastUpdate(withLocation location : CLLocationCoordinate2D){
        let fullPath = URLPath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest (url: URL(string: fullPath)!)
        let task = URLSession.shared.dataTask(with: request){ [weak self] (data, response, error) in
            guard error == nil
                else{
                    return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let daily = json["daily"] as? [String : Any],
                    let data = daily["data"] as? [[String : Any]],
                    let firstNextDayHigh = data[3]["temperatureHigh"] as? Double {
                    self!.firstHigh = String(Int(firstNextDayHigh))
                    print(self!.firstHigh)
                    }
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let daily = json["daily"] as? [String : Any],
                    let data = daily["data"] as? [[String : Any]],
                    let firstNextDayLow = data[3]["temperatureLow"] as? Double {
                    self!.firstLow = String(Int(firstNextDayLow))
                }
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let daily = json["daily"] as? [String : Any],
                    let data = daily["data"] as? [[String : Any]],
                    let secondNextDayHigh = data[4]["temperatureHigh"] as? Double {
                    self!.secondHigh = String(Int(secondNextDayHigh))
                }
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let daily = json["daily"] as? [String : Any],
                    let data = daily["data"] as? [[String : Any]],
                    let secondNextDayLow = data[4]["temperatureLow"] as? Double {
                    self!.secondLow = String(Int(secondNextDayLow))
                }
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let daily = json["daily"] as? [String : Any],
                    let data = daily["data"] as? [[String : Any]],
                    let ThirdNextDayHigh = data[5]["temperatureHigh"] as? Double {
                    self!.ThirdHigh = String(Int(ThirdNextDayHigh))
                }
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let daily = json["daily"] as? [String : Any],
                    let data = daily["data"] as? [[String : Any]],
                    let ThirdNextDayLow = data[5]["temperatureLow"] as? Double {
                    self!.ThirdLow = String(Int(ThirdNextDayLow))
                }
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let daily = json["daily"] as? [String : Any],
                    let data = daily["data"] as? [[String : Any]],
                    let todaySum = data[3]["summary"] as? String {
                    self!.todaySummary = todaySum
                }
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let daily = json["daily"] as? [String : Any],
                    let data = daily["data"] as? [[String : Any]],
                    let firstNextDayLow = data[3]["temperatureLow"] as? Double {
                    self!.firstLow = String(Int(firstNextDayLow))
                }
                
                DispatchQueue.main.async
                {
                    self!.dayOneHighTempLabel.text = self!.firstHigh + " °F"
                    self!.dayOneLowTempLabel.text = self!.firstLow + " °F"
                    self!.dayTwoHighTempLabel.text = self!.secondHigh + " °F"
                    self!.dayTwoLowTempLabel.text = self!.secondLow + " °F"
                    self!.dayThreeHighTempLabel.text = self!.ThirdHigh + " °F"
                    self!.dayThreeLowTempLabel.text = self!.ThirdLow + " °F"
                }
            }
            catch let jsonError
            {
                print(jsonError.localizedDescription)
            }
        }
        task.resume()
    }
    // display current date
    func date(){
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMd")
        //formatter.dateFormat = "dd-MM"
        let daymatter = DateFormatter()
        daymatter.dateFormat = "EEEE"
        let weekDay = daymatter.string(from: Date())
        
        dayNow.text = weekDay
        dateNow.text = formatter.string(from: Date())
        dateFirst.text = formatter.string(from: Date().addingTimeInterval(86400))
        dateSecond.text = formatter.string(from: Date().addingTimeInterval(172800))
        dateThird.text = formatter.string(from: Date().addingTimeInterval(259200))
    }
    // display current time
    func clock()
    {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        //let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        var tempMin:String = ""
        let hour = String(components.hour!)
        
        if components.minute! == 0{
            tempMin = "00"
        }
        else if components.minute! < 10{
            tempMin = "0"+String(components.minute!)
        }
        else{
            tempMin = String(components.minute!)
        }
        let minute = tempMin
        //let second = String(components.second!)
        
        let time = hour+":"+minute
        //let time = hour+":"+minute+":"+second
        timeLabel.text = time
    }
    // update clock every miniute
    func runTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.timeChecker)), userInfo: nil, repeats: true)
    }
    
    @objc func timeChecker()
    {
        seconds -= 1
        clock()
        if seconds == 0 {
            seconds = 60
        }
        
    }
}

