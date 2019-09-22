//
//  IconView.swift
//  AppCodingChallenge
//
//  Created by YongHwan Kim on 9/20/19.
//  Copyright © 2019 YongHwan Kim. All rights reserved.
//

import Foundation
import UIKit

class IconView: UIView {
    //static var iconStorm : UIImage = UIImage(named: "icon-weather-storm-512.png")!
    static var iconStorm = #imageLiteral(resourceName: "storm")
    
    //static var iconCloudy : UIImage = UIImage(named: "icon-weather-cloudlight-512.png")!
    static var iconCloudy = #imageLiteral(resourceName: "cloudy")
    
    //static var iconSunny : UIImage = UIImage(named: "icon-weather-sunny-512.png")!
    static var iconSunny = #imageLiteral(resourceName: "sunny")
    
    //static var iconHeavyRain : UIImage = UIImage(named: "icon-weather-rainheavy-512.png")!
    static var iconHeavyRain = #imageLiteral(resourceName: "rainheavy")
    
    //static var iconSnow : UIImage = UIImage(named: "icon-weather-snowheavy-512.png")!
    static var iconSnow = #imageLiteral(resourceName: "snowheavy")
    
    //static var noImage : UIImage = UIImage(named: "Remove-512.png")!
    static var noImage = #imageLiteral(resourceName: "Remove")
    // returning icon data
    static func drawIcon(iconType:String) -> UIImage?
    {
        if (iconType == "Mostly Cloudy" || iconType == "partly-cloudy-night" || iconType == "cloudy" || iconType == "partly-cloudy-day" || iconType == "fog"){
            return iconCloudy
        }
        else if (iconType == "clear-day" || iconType == "clear-night"){
            
            return iconSunny
        }
        else if iconType == "rain"{
            
            return iconHeavyRain
        }
        else if (iconType == "snow" || iconType == "sleet"){
            
            return iconSnow
        }
        else if iconType == "thunderstorm"{
            
            return iconStorm
        }
        return noImage
    }
}
