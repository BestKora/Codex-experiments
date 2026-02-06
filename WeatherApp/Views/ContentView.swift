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
                        VStack(spacing: 20) {
                            WeatherSummaryView(weather: weather, city: viewModel.selectedCity)
                            if !viewModel.dailyForecast.isEmpty {
                                DailyForecastView(forecast: viewModel.dailyForecast)
                            }
                        }
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
                WeatherMetricView(
                    title: "Temp",
                    value: weather.temperature.formatted(
                        .measurement(width: .abbreviated, numberFormatStyle: .number.precision(.fractionLength(0)))
                    )
                )
                WeatherMetricView(
                    title: "Feels like",
                    value: weather.apparentTemperature.formatted(
                        .measurement(width: .abbreviated, numberFormatStyle: .number.precision(.fractionLength(0)))
                    )
                )
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

private struct DailyForecastView: View {
    let forecast: [DayWeather]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("7-Day Forecast")
                .font(.headline)

            ForEach(forecast, id: \.date) { day in
                HStack {
                    Text(day.date.formatted(.dateTime.weekday()))
                        .frame(width: 90, alignment: .leading)

                    Image(systemName: day.symbolName)
                        .foregroundStyle(.blue)
                        .frame(width: 24)

                    Text(day.condition.description)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(
                        day.lowTemperature.formatted(
                            .measurement(width: .abbreviated, numberFormatStyle: .number.precision(.fractionLength(0)))
                        )
                    )
                        .foregroundStyle(.secondary)

                    Text(
                        day.highTemperature.formatted(
                            .measurement(width: .abbreviated, numberFormatStyle: .number.precision(.fractionLength(0)))
                        )
                    )
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
