import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    private let networkManager = NetworkManager()
    
    func loadWeather(city: String) {
         isLoading = true
         weather = nil
        networkManager.fetchWeather(city: city ) { [weak self] result in
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
