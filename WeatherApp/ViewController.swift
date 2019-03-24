//
//  ViewController.swift
//  WeatherApp
//
//  Created by Arman Husic on 3/22/19.
//  Copyright © 2019 Arman Husic. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    
    let gradientLayer = CAGradientLayer()
    let apiKey = "9ecb64bb6b5ab0f3deaf2e11e6bf6952"
    // define sample default latitude and longitude
    var latitude = 11.344533
    var longitude = 104.33322
    var activityIndicator: NVActivityIndicatorView!
    // get users location from CLLocationManager
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backgroundView.layer.addSublayer(gradientLayer)
        
        let indicatorSize: CGFloat = 90
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 35.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        // to use activityIndicator (loading) call activityIndicator.startAnimating() or .stopAnimating()
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
    }
    
    // function called whenever location information is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                let jsonCountry = jsonResponse["sys"]
                let jsonWindSpeed = jsonResponse["wind"]
                
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.descriptionLabel.text = jsonWeather["description"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                self.tempMaxLabel.text = "\(Int(round(jsonTemp["temp_max"].doubleValue)))"
                self.tempMinLabel.text = "\(Int(round(jsonTemp["temp_min"].doubleValue)))"
                self.humidityLabel.text = "\(Int(round(jsonTemp["humidity"].doubleValue)))"
                self.countryLabel.text = jsonCountry["country"].stringValue
                self.windSpeedLabel.text = "\(Int(jsonWindSpeed["speed"].doubleValue))"
                
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if(suffix == "n"){
                    self.setGreyGradientBackground()
                } else {
                    self.setBlueGradientBackground()
                }
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    
// Gradient Background Color functions
    
    func setBlueGradientBackground() {
        let topColor = UIColor(red: 90.0/255.0, green: 160.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 75.0/255.0, green: 120.0/255.0, blue: 190.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setGreyGradientBackground() {
        let topColor = UIColor(red: 166.0/255.0, green: 166.0/255.0, blue: 166.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 62.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
        
    }
    
}

