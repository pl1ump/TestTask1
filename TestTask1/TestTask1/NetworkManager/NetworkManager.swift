import Foundation

class NetworkManager {
    let apiKey = "d3322ac1b76c41b7ea438325914b120b"
    
    func fetchWeather(city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org")
        urlComponents?.path = "/data/2.5/weather"
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: "d3322ac1b76c41b7ea438325914b120b"),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let url = urlComponents?.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            guard let data else { return }
            print(String(decoding: data, as: UTF8.self))
            
            do {
                let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(result))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func fetchForecast(city: String, completion: @escaping (Result<(City, [Forecast]), Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org")
        urlComponents?.path = "/data/2.5/forecast"
        urlComponents?.queryItems = [
        URLQueryItem(name: "q", value: city),
        URLQueryItem(name: "appid", value: "d3322ac1b76c41b7ea438325914b120b"),
        URLQueryItem(name: "units", value: "metric")]
        
        guard let url = urlComponents?.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription)
                completion(.failure(error!))
                return
            }
            guard let data else { return }
            print(String(decoding: data, as: UTF8.self))
            
            do {
                let result = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(.success((result.city, result.list)))
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
        } .resume()
    }
}

