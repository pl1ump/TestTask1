import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    private let networkManager = NetworkManager()
    
    func loadWeather(lat: Double, lon: Double) {
         isLoading = true
         weather = nil
        networkManager.fetchWeather(lat: lat, lon: lon) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherData):
                    self?.weather = weatherData
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.isLoading = false
            }
        }
    }
}
