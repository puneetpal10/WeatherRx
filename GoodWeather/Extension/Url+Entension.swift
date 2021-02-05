//
//  Url+Entension.swift
//  GoodWeather
//
//  Created by PuNeet on 03/02/21.
//  Copyright © 2021 Mohammad Azam. All rights reserved.
//

import Foundation


extension URL{
    static func urlForWeatherAPI(_ city : String) -> URL?{
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=c7c68cd1046f859a403e5979594ff4df&units=imperial")
    }
}
