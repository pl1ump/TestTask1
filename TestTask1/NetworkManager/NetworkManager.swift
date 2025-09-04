import Foundation

class NetworkManager {
    let apiKey = "d3322ac1b76c41b7ea438325914b120b"
    
    func fetchWeather(city: String) async throws -> WeatherResponse {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org")
        urlComponents?.path = "/data/2.5/weather"
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: "d3322ac1b76c41b7ea438325914b120b"),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        print(String(decoding: data, as: UTF8.self))
        
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    func fetchForecast(city: String) async throws -> (City, [Forecast]) {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org")
        urlComponents?.path = "/data/2.5/forecast"
        urlComponents?.queryItems = [
        URLQueryItem(name: "q", value: city),
        URLQueryItem(name: "appid", value: "d3322ac1b76c41b7ea438325914b120b"),
        URLQueryItem(name: "units", value: "metric")]
        
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }
        let(data, response) = try await URLSession.shared.data(from: url)
        print(String(decoding: data, as: UTF8.self))
        
        let result = try JSONDecoder().decode(ForecastResponse.self, from: data)
        return (result.city, result.list)
    }
}

