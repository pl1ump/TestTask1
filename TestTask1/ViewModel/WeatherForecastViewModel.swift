import Foundation
@MainActor
class WeatherForecastViewModel: ObservableObject  {
    @Published var weatherForecasts = [Forecast]()
    @Published var city: City?
    @Published var errorMessage: String?
    @Published var isLoading = false
    var groupedForecasts: [String: [Forecast]] {
        Dictionary(grouping: weatherForecasts) { forecast in
            String(forecast.dt_txt.prefix(10))
        }
    }
    
    private var networkManager = NetworkManager()
    
    func forecastsLoad(city: String) {
        Task {
            isLoading = true
            weatherForecasts = []
            errorMessage = nil
            
            do {
                let (loadedCity, forecast) = try await networkManager.fetchForecast(city: city)
                self.city = loadedCity
                self.weatherForecasts = forecast
            }
            catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
        
        
       
        
        
    }
    
    func formatDate(_ dateStr: String) -> String {
        dateStr.toDate("yyyy-MM-dd")?.toString("EEEE, d MMM") ?? dateStr
    }
    
    func formatTime(_ dateStr: String) -> String {
        dateStr.toDate("yyyy-MM-dd HH:mm:ss")?.toString("HH:mm") ?? dateStr
    }
}
