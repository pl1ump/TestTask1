import Foundation
class WeatherForecastViewModel: ObservableObject  {
    @Published var weaterForecasts = [Forecast]()
    @Published var city: City?
    @Published var errorMessage: String?
    @Published var isLoading = false
    var groupedForecasts: [String: [Forecast]] {
        Dictionary(grouping: weaterForecasts) { forecast in
            String(forecast.dt_txt.prefix(10)) 
        }
    }
    
    private var networkManager = NetworkManager()
    
    func forecastsLoad(city: String) {
        isLoading = true
        weaterForecasts = []
        errorMessage = nil
        
        networkManager.fetchForecast(city: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (city, forecasts)):
                    self?.city = city
                    self?.weaterForecasts = forecasts
                case .failure(let error):
                    print("Error:" , error.localizedDescription)
                }
                self?.isLoading = false
            }
        }
        
    }
    
    func formatDate(_ dateStr: String) -> String {
        dateStr.toDate("yyyy-MM-dd")?.toString("EEEE, d MMM") ?? dateStr
    }
    
    func formatTime(_ dateStr: String) -> String {
        dateStr.toDate("yyyy-MM-dd HH:mm:ss")?.toString("HH:mm") ?? dateStr
    }
}
