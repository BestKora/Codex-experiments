import CoreLocation
import WeatherKit

struct WeatherKitService {
    private let service = WeatherService.shared

    func currentWeather(for coordinate: CLLocationCoordinate2D) async throws -> CurrentWeather {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let weather = try await service.weather(for: location)
        return weather.currentWeather
    }
}
