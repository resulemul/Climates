//
//  WeatherData.swift
//  Climates
//
//  Created by Resul Emül on 7/27/20.
//  Copyright © 2020 NeviPlay. All rights reserved.
//

import Foundation
struct WeatherData:Decodable {
    let name: String
    let main: Main
    let weather:[Weather]
}
struct Main: Decodable {
    let temp: Double
}
struct Weather: Decodable {
    let description: String
}
