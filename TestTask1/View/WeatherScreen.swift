import SwiftUI

struct WeatherScreen: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city = ""
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                TextField("Enter city", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Search") {
                    viewModel.loadWeather(city: city)
                }
            }
            .padding()
            Spacer()
            
            if viewModel.isLoading {
                Text("Weather is loading")
            } else if let weather = viewModel.weather {
                Text(weather.name)
                    .font(.largeTitle)
                    .bold()
                
                Text("\(Int(weather.main.temp))°C")
                    .font(.system(size: 64))
                    .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(weather.weather, id: \.icon) { condition in
                        HStack {
                            AsyncImage(
                                url: URL(string: "https://openweathermap.org/img/wn/\(condition.icon)@2x.png"))
                            { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            } placeholder: {
                                ProgressView()
                            }
                            Text(condition.description.capitalized)
                                .font(.headline)
                        }
                    }
                }
            }   else {
                Text("No data")
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WeatherScreen()
}
