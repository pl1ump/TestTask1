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
            ForecastView()
                .tabItem {
                    Image(systemName: "globe.europe.africa")
                    Text("Forecast")
                }
            WeatherScreen()
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
