// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreLocation

public class RealtimeLocationUpdate: NSObject, ObservableObject {
    public var text = "hello, RealtimeLocationUpdate"
    
    public var updates: CLLocationUpdate.Updates
   
    @Published
    public var latestLocation: CLLocation?
    @Published
    public var authorizationStatus: CLAuthorizationStatus
    
    @Published
    public var locationHistoryList: [CLLocation] = []
    
    private let locationManager: CLLocationManager
    
    public override init() {
        locationManager = CLLocationManager()
        updates = CLLocationUpdate.liveUpdates()
        authorizationStatus = locationManager.authorizationStatus
        super.init()
    }
    
    public func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    public func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    public func getLocation() async throws {
        for try await update in updates {
            guard let location = update.location else { return }
            DispatchQueue.main.async {
                self.locationHistoryList.append(location)
                self.latestLocation = location
            }
        }
    }
}

