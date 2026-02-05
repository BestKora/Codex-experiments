import CoreLocation

struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let state: String
    let coordinate: CLLocationCoordinate2D

    var displayName: String {
        "\(name), \(state)"
    }
}

extension City {
    static let americanCities: [City] = [
        City(name: "New York", state: "NY", coordinate: .init(latitude: 40.7128, longitude: -74.0060)),
        City(name: "Los Angeles", state: "CA", coordinate: .init(latitude: 34.0522, longitude: -118.2437)),
        City(name: "Chicago", state: "IL", coordinate: .init(latitude: 41.8781, longitude: -87.6298)),
        City(name: "Miami", state: "FL", coordinate: .init(latitude: 25.7617, longitude: -80.1918)),
        City(name: "Seattle", state: "WA", coordinate: .init(latitude: 47.6062, longitude: -122.3321)),
        City(name: "Denver", state: "CO", coordinate: .init(latitude: 39.7392, longitude: -104.9903)),
        City(name: "Austin", state: "TX", coordinate: .init(latitude: 30.2672, longitude: -97.7431)),
        City(name: "Boston", state: "MA", coordinate: .init(latitude: 42.3601, longitude: -71.0589)),
        City(name: "Phoenix", state: "AZ", coordinate: .init(latitude: 33.4484, longitude: -112.0740)),
        City(name: "San Francisco", state: "CA", coordinate: .init(latitude: 37.7749, longitude: -122.4194))
    ]
}
