//
//  HomeViewController.swift
//  weather-track
//
//  Created by David Bowen on 6/21/18.
//  Copyright © 2018 David Bowen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var displayLocationLabel: UILabel!
    @IBOutlet weak var day2Temp: UILabel!
    @IBOutlet weak var day3Temp: UILabel!
    @IBOutlet weak var day4Temp: UILabel!
    @IBOutlet weak var day5Temp: UILabel!
    @IBOutlet weak var day6Temp: UILabel!
    @IBOutlet weak var day7Temp: UILabel!
    @IBOutlet weak var day8Temp: UILabel!
    @IBOutlet weak var day9Temp: UILabel!
    
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var date3: UILabel!
    @IBOutlet weak var date4: UILabel!
    @IBOutlet weak var date5: UILabel!
    @IBOutlet weak var date6: UILabel!
    @IBOutlet weak var date7: UILabel!
    @IBOutlet weak var date8: UILabel!
    @IBOutlet weak var date9: UILabel!
    
    let locationManager = CLLocationManager()
    
    
    var dateArray: [String] = []
    var myArray: [String] = [ ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func update(_ sender: Any) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                let locationName = placemarks?.first?.locality ?? "Unknown Location"
                self.displayLocationLabel.text = locationName
            }
            
            Alamofire.request("https://api.darksky.net/forecast/2c0e34dba4c9f289306ed7a074e79353/\(latitude),\(longitude)").responseJSON { response in
                switch response.result {
                case .success(let value) :
                    var json = JSON(value)
                    let currentWeather = json["currently"]
                    let dailyWeather = json["daily"]
                    let summary = dailyWeather["summary"]
                    guard let schedules = dailyWeather["data"].array else { print("no"); fatalError() }
                    for schedule in schedules {
                        let temp = schedule["temperatureHigh"].float!
                        let tempValue = String(format: "%.0f", temp) + "ºF"
                        self.myArray.append(tempValue)
                    }
                    
                    guard let times = dailyWeather["data"].array else { print("no"); fatalError() }
                    for time in times {
                        let temp = time["time"].double!
                        let date = Date(timeIntervalSince1970: temp)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
                        dateFormatter.locale = NSLocale.current
                        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm" //Specify your format that you want
                        let strDate = dateFormatter.string(from: date)
                        self.dateArray.append(strDate)

                    }
                    
                    let time = currentWeather["time"].double!

                    let date = Date(timeIntervalSince1970: time)
    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm" //Specify your format that you want
                    let strDate = dateFormatter.string(from: date)
                    
                    
                    let temperature = currentWeather["temperature"].float
                    let temperatureValue = String(format: "%.0f", temperature!) + "ºF"

                    self.date1.text = strDate
                    self.temperatureLabel.text = temperatureValue
             
                    self.day3Temp.text = self.myArray[1]
                    self.day4Temp.text = self.myArray[2]
                    self.day5Temp.text = self.myArray[3]
                    self.day6Temp.text = self.myArray[4]
                    self.day7Temp.text = self.myArray[5]
                    self.day8Temp.text = self.myArray[6]
                    self.day9Temp.text = self.myArray[7]
             
                    self.date3.text = self.dateArray[1]
                    self.date4.text = self.dateArray[2]
                    self.date5.text = self.dateArray[3]
                    self.date6.text = self.dateArray[4]
                    self.date7.text = self.dateArray[5]
                    self.date8.text = self.dateArray[6]
                    self.date9.text = self.dateArray[7]
                    
     
                case .failure(let error) :
                    fatalError(error.localizedDescription)
                    
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
