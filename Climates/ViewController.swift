//
//  ViewController.swift
//  Climates
//
//  Created by Resul Emül on 7/26/20.
//  Copyright © 2020 NeviPlay. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var degreeShower: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityShower: UILabel!
    
    var jsonCityName = "City"
    let apiUrl = "https://api.openweathermap.org/data/2.5/weather?q="
    let apiKey = "&appid=26ad45777543ee87e4c999f0699778a2"
    var city = ""
    var requestStringURL = ""
    var units = "&units=metric"
    var locationLong = ""
    var locationLati = ""
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchField.delegate = self
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    

    @IBAction func locationButtonTapped(_ sender: UIButton) {
        if locationLong != "" {
        requestStringURL = "https://api.openweathermap.org/data/2.5/weather?"+"lat=\(locationLati)&lon=\(locationLong)"+units+apiKey
            performRequest(urlString: requestStringURL)
            print(requestStringURL)
        }
    }
    @IBAction func swithDegree(_ sender: UISwitch) {
        if sender.isOn {
            units = "&units=metric"
            degreeLabel.text = "°C"
        } else {
            units = "&units=imperial"
            degreeLabel.text = "°F"
        }
        if requestStringURL != "" {
            requestStringURL = apiUrl+city+units+apiKey
            performRequest(urlString: requestStringURL)
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        city = searchBar.text?.replacingOccurrences(of: " ", with: "+") ?? ""
        requestStringURL = apiUrl+city+units+apiKey
        performRequest(urlString: requestStringURL)
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
    func performRequest(urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                if let safeData = data {
                    self.parseJason(weatherData: safeData)
                    print(safeData)
                    
                }
            }
            task.resume()
        }
        
    }
    
    func parseJason(weatherData: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                self.jsonCityName = decodedData.name
            DispatchQueue.main.async {
                self.cityShower.text = self.jsonCityName
                self.degreeShower.text = String(decodedData.main.temp)
                print(decodedData.weather[0].description)
                
                let myURLString = "https://openweathermap.org/img/wn/10d@2x.png"
                let myURL = URL(string: myURLString)!
                let myData = try! Data(contentsOf: myURL)
                let myImage = try? UIImage(data: myData)
                self.weatherIcon.image = myImage
            }
            
            
        } catch {
            print(error)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        locationLati = String(locValue.latitude)
        locationLong = String(locValue.longitude)
        
    }


    
    
}

