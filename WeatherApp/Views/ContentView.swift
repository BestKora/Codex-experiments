import SwiftUI
import WeatherKit

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Picker("City", selection: $viewModel.selectedCity) {
                    ForEach(City.americanCities) { city in
                        Text(city.displayName).tag(city)
                    }
                }
                .pickerStyle(.menu)

                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading weather...")
                    } else if let weather = viewModel.currentWeather {
                        WeatherSummaryView(weather: weather, city: viewModel.selectedCity)
                    } else if let message = viewModel.errorMessage {
                        ContentUnavailableView("Weather Unavailable", systemImage: "cloud.sun.bolt", description: Text(message))
                    } else {
                        ContentUnavailableView("Select a city", systemImage: "location", description: Text("Pick a city to see current weather conditions."))
                    }
                }
                .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding()
            .navigationTitle("US Weather")
            .task(id: viewModel.selectedCity) {
                await viewModel.loadWeather()
            }
        }
    }
}

private struct WeatherSummaryView: View {
    let weather: CurrentWeather
    let city: City

    var body: some View {
        VStack(spacing: 16) {
            Text(city.displayName)
                .font(.title2.bold())

            Image(systemName: weather.symbolName)
                .font(.system(size: 64))
                .foregroundStyle(.orange)

            Text(weather.condition.description)
                .font(.title3)

            HStack(spacing: 20) {
                WeatherMetricView(title: "Temp", value: weather.temperature.formatted())
                WeatherMetricView(title: "Feels like", value: weather.apparentTemperature.formatted())
            }

            HStack(spacing: 20) {
                WeatherMetricView(title: "Humidity", value: weather.humidity.formatted(.percent))
                WeatherMetricView(title: "Wind", value: weather.wind.speed.formatted())
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct WeatherMetricView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
