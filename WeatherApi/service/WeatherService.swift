//
//  Service.swift
//  WeatherApi
//
//  Created by Johan Nilsson on 2020/04/27.
//  Copyright © 2020 Johan Nilsson. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherService {
    
    let unknownText = "Unknown"
    var locationCityName: String?
    var locationLatitude = 0.0
    var locationLongitude = 0.0
    var location: Location?
    
    let apiKey = "95e2e94ea24ac96e4906922370157046" // Should be kept secret
    var forecastList = [Forecast]() // Use an empty array/list insted of Optional
    
    func fetchLatestForcastLocation() -> Location {
        return location ?? Location(name: locationCityName ?? unknownText, latitude: locationLatitude, longitude: locationLongitude)
    }
    
    // let urlString = "https://api.openweathermap.org/data/2.5/weather?q=Cape%20Town&units=metric&appid=" + apiKey
    // let urlString = "https://api.openweathermap.org/data/2.5/forecast?lon=18.42&lat=-33.93&units=metric&appid=" + apiKey
    
    // fileprivate - This should be private
    func buildUrlString(_ longitude: Double?, _ latitude: Double?, _ city: String?) -> String {
        var url = "https://api.openweathermap.org/data/2.5/forecast?"
        if longitude != nil && latitude != nil {
            url += "lon=" + String(longitude!) + "&lat=" + String(latitude!) + "&units=metric&appid="
        } else if city != nil || city?.count ?? 0 > 0 {
            url += "q=" + city!.replacingOccurrences(of: " ", with: "%20") + "&units=metric&appid="
        } else {
            // default e.g. Cape Town
            url += "lon=18.42&lat=-33.93&units=metric&appid="
        }
        url += apiKey
        return url
    }
    
    func fetchForcast(city: String?, longitude: Double?, latitude:Double?) -> [Forecast]? {
        // reset internal storage
        forecastList = [Forecast]()
        locationCityName = nil
        locationLatitude = 0.0
        locationLongitude = 0.0
        
        let urlString = buildUrlString(longitude, latitude, city)
        print(urlString)
        let url = URL(string: urlString)
        let request = URLRequest(url: url!) // OK to use ! there - I am setting the string
        //      let request = URLRequest(url: url!,timeoutInterval: Double.infinity) // OK to use ! there - I am setting the string
        let semaphore = DispatchSemaphore (value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let json = try JSON(data: data);
                let nameResult = json["city"]["name"]
                if let name = nameResult.string {
                    self.locationCityName = name
                } else {
                    print(nameResult.error ?? "unknown error")
                }
                
                let latResult = json["city"]["coord"]["lat"]
                if let lat = latResult.double {
                    self.locationLatitude = lat
                } else {
                    print(nameResult.error ?? "unknown error")
                }
                
                let lonResult = json["city"]["coord"]["lon"]
                if let lon = lonResult.double {
                    self.locationLongitude = lon
                } else {
                    print(nameResult.error ?? "unknown error")
                }
                
                self.location = Location(name: self.locationCityName ?? self.unknownText, latitude: self.locationLatitude , longitude: self.locationLongitude )
                print("self.location")
                print(self.location!)
                
                let forecastResult = json["list"]
                if let forecastList = forecastResult.array {
                    for forecastObject in forecastList {
                        let temp = forecastObject["main"]["temp"].double ?? 0.0
                        let weatherMain = forecastObject["weather"][0]["main"].string ?? self.unknownText
                        let weatherDescription = forecastObject["weather"][0]["description"].string ?? self.unknownText
                        let weatherIcon = forecastObject["weather"][0]["icon"].string ?? ""
                        let w = Weather(main: weatherMain, description: weatherDescription, icon: weatherIcon)
                        let dateText = forecastObject["dt_txt"].string ?? self.unknownText
                        let f = Forecast(temp: temp, weather: w, dateText: dateText)
                        self.forecastList.append(f)
                    }
                } else {
                    print(forecastResult.error ?? "unknown error")
                }
                print("self.forecastList")
                print(self.forecastList)
                
//                DispatchQueue.main.async {
//                    print("inside DispatchQueue.main.async")
//                }
                
            } catch {
                print("catch JSON Error")
            }
            print("before semaphore.signal()")
            semaphore.signal()
            print("after semaphore.signal()")
        }
        print("before task.resume()")
        task.resume()
        print("after task.resume()")
        print("before semaphore.wait()")
        semaphore.wait()
        print("after semaphore.wait()")
        return forecastList
    }
}
