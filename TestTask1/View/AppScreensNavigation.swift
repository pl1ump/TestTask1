//
//  AppScreensNavigation.swift
//  TestTask1
//
//  Created by Vladick  on 19/09/2025.
//

import SwiftUI

struct AppScreensNavigation: View {
    var body: some View {
        TabView {
            ForecastView(viewModel: WeatherForecastViewModel(networkManager: NetworkManager()))
                .tabItem {
                    Image(systemName: "globe.europe.africa")
                    Text("Forecast")
                }
            WeatherScreen(viewModel: WeatherViewModel(networKManager: NetworkManager()))
                .tabItem {
                    Image(systemName: "sun.max")
                    Text("Weather now")
                }
        }
    }
}

#Preview {
    AppScreensNavigation()
}
