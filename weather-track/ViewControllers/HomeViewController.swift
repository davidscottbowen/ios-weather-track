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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("https://api.darksky.net/forecast/2c0e34dba4c9f289306ed7a074e79353/37.8145,-82.8071").responseJSON { response in
            switch response.result {
            case .success(let value) :
                var json = JSON(value)
                let currentWeather = json["currently"]
                let temperature = currentWeather["temperature"].float
                let temperatureValue = String(format: "%.0f", temperature!) + "ºF"
                self.temperatureLabel.text = temperatureValue
                
            case .failure(let error) :
                fatalError(error.localizedDescription)
                
            }
        }
        
        
        // Do any additional setup after loading the view.
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
