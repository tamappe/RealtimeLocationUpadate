// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreLocation

public class RealtimeLocationUpdate {
    public var text = "hello, RealtimeLocationUpdate"
    
    public var updates: CLLocationUpdate.Updates
    public var latestLocation: CLLocation?
    
    public init() {
        updates = CLLocationUpdate.liveUpdates()
    }
    
    func checkUserPermission() {
        
    }
    
    func getLocation() async throws {
        for try await update in updates {
            guard let location = update.location else { return }
            latestLocation = location
        }
    }
}

