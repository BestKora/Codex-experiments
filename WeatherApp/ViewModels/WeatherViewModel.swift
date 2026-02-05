import Combine
import CoreLocation
import Foundation
import WeatherKit

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var selectedCity: City = City.americanCities.first ?? City(name: "New York", state: "NY", coordinate: .init(latitude: 40.7128, longitude: -74.0060))
    @Published var currentWeather: CurrentWeather?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let weatherService = WeatherKitService()

    func loadWeather() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            currentWeather = try await weatherService.currentWeather(for: selectedCity.coordinate)
        } catch is CancellationError {
            return
        } catch {
            errorMessage = "Unable to load weather. \(error.localizedDescription)"
            currentWeather = nil
        }
    }
}
