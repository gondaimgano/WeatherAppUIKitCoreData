// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let currentWeatherResponse = try? newJSONDecoder().decode(CurrentWeatherResponse.self, from: jsonData)

import Foundation

// MARK: - CurrentWeatherResponseModel
struct CurrentWeatherResponseModel: Codable {
    let coord: CoordItem?
    let weather: [WeatherItem]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: WindItem?
    let rain: RainItem?
    let clouds: CloudsItem?
    let dt: Int?
    let sys: SysItem?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds
struct CloudsItem: Codable {
    let all: Int?
}

// MARK: - Coord
struct CoordItem: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain
struct RainItem: Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Sys
struct SysItem: Codable {
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct WeatherItem: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct WindItem: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
