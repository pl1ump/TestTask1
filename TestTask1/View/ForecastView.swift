import SwiftUI

struct ForecastView: View {
    @StateObject private var viewModel = WeatherForecastViewModel(networkManager: NetworkManager())
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search city", text: $viewModel.city)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        
                    Button("Search") {
                        Task {
                            await viewModel.loadForecast()
                        }
                    }
                    .padding(.trailing)
                }
                Group {
                    if viewModel.isLoading {
                        ProgressView("Загружаєм прогноз…")
                    } else if let error = viewModel.errorMessage {
                        Text("Помилка: \(error)")
                            .foregroundColor(.red)
                    } else {
                        List {
                            ForEach(viewModel.groupedForecasts.keys.sorted(), id: \.self) { day in
                                ForecastSection(
                                    day: day,
                                    forecasts: viewModel.groupedForecasts[day] ?? [],
                                    viewModel: viewModel
                                )
                            }
                        }
                    }
                }
                .navigationTitle(viewModel.cityInfo?.name ?? "Прогноз")
            }
            .background(Color(uiColor: .systemGray6))
        }
        .task {
            await viewModel.loadForecast()
        }
    }
}

// MARK: - forecast for one day
struct ForecastSection: View {
    let day: String
    let forecasts: [Forecast]
    let viewModel: WeatherForecastViewModel
    
    var body: some View {
        Section(header: Text(viewModel.formatDate(day))) {
            ForEach(forecasts, id: \.dt) { forecast in
                ForecastRow(forecast: forecast, viewModel: viewModel)
            }
        }
    }
}

// MARK: - Forecast row
struct ForecastRow: View {
    let forecast: Forecast
    let viewModel: WeatherForecastViewModel
    
    var body: some View {
        HStack {
            // Time
            Text(viewModel.formatTime(forecast.dt_txt))
                .frame(width: 50, alignment: .leading)
            
            // Icon
            AsyncImage(
                url: URL(string: "https://openweathermap.org/img/wn/\(forecast.weather.first?.icon ?? "01d")@2x.png")
            ) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            
            // Temp
            Text("\(Int(forecast.main.temp))°C")
                .font(.headline)
            
            Spacer()
            
            // Description
            Text(forecast.weather.first?.description.capitalized ?? "")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    ForecastView()
}
