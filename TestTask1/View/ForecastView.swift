//
//  ForecastView.swift
//  TestTask1
//
//  Created by Vladick  on 30/08/2025.
//

import SwiftUI

struct ForecastView: View {
    @StateObject private var viewModel = WeatherForecastViewModel()
    var body: some View {
           NavigationView {
               Group {
                   if viewModel.isLoading {
                       ProgressView("Загружаєм прогноз…")
                   } else if let error = viewModel.errorMessage {
                       Text("Помилка: \(error)")
                           .foregroundColor(.red)
                   } else {
                       List {
                           ForEach(viewModel.groupedForecasts.keys.sorted(), id: \.self) { day in
                               Section(header: Text(viewModel.formatDate(day))) {
                                   ForEach(groupedForecasts[day] ?? [], id: \.dt) { forecast in
                                       HStack {
                                          
                                           Text(viewModel.formatTime(forecast.dt_txt))
                                               .frame(width: 50, alignment: .leading)
                                           
                                           
                                           AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(forecast.weather.first?.icon ?? "01d")@2x.png")) { image in
                                               image.resizable()
                                           } placeholder: {
                                               ProgressView()
                                           }
                                           .frame(width: 40, height: 40)
                                           
                                          
                                           Text("\(Int(forecast.main.temp))°C")
                                               .font(.headline)
                                           
                                           Spacer()
                                           
                                           
                                           Text(forecast.weather.first?.description.capitalized ?? "")
                                               .foregroundColor(.gray)
                                       }
                                   }
                               }
                           }
                       }
                   }
               }
               .navigationTitle(viewModel.city?.name ?? "Прогноз")
           }
           .onAppear {
               viewModel.forecastsLoad(city: "Cherkasy")
           }
       }
       
       
       private var groupedForecasts: [String: [Forecast]] {
           Dictionary(grouping: viewModel.weatherForecasts) { forecast in
               String(forecast.dt_txt.prefix(10))
           }
       }
        
}

#Preview {
    ForecastView()
}
