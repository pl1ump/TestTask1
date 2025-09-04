import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let networkManager = NetworkManager()
    
    func loadWeather(city: String) {
         
        Task {
            do {
                isLoading = true
                errorMessage = nil
                let result = try await networkManager.fetchWeather(city: city)
                weather = result
            }
            catch {
                errorMessage = error.localizedDescription
                print("Помилка: \(error)")
            }
            isLoading = false
        }
    }
}
