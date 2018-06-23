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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var displayLocationLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            print(latitude)
            print(longitude)
            
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                let locationName = placemarks?.first?.locality ?? "Unknown Location"
                self.displayLocationLabel.text = locationName
            }
            
            Alamofire.request("https://api.darksky.net/forecast/2c0e34dba4c9f289306ed7a074e79353/\(latitude),\(longitude)").responseJSON { response in
                switch response.result {
                case .success(let value) :
                    var json = JSON(value)
                    let currentWeather = json["currently"]
                    print(currentWeather)
                    let temperature = currentWeather["temperature"].float
                    let temperatureValue = String(format: "%.0f", temperature!) + "ºF"
                    self.temperatureLabel.text = temperatureValue
                    
                case .failure(let error) :
                    fatalError(error.localizedDescription)
                    
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            errorLabel.text = "Cannot determine location at this time"
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
