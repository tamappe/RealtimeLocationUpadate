// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreLocation

public class RealtimeLocationUpdate: NSObject, ObservableObject {
    
    public var updates: CLLocationUpdate.Updates
   
    @Published
    public var latestLocation: CLLocation?
    public var backgroundActivity: CLBackgroundActivitySession?
    @Published
    public var authorizationStatus: CLAuthorizationStatus
    
    @Published
    public var locationHistoryList: [CLLocation] = []
    
    // 強制停止用フラグ
    @Published
    public var isForceStop: Bool = false
    // バックグラウンドモード, アプリの権限が「使用中」でもバックグラウンドで取得できる
    @Published
    public var isBackgroundMode: Bool
    public var isStationary: Bool = false
    
    private let locationManager: CLLocationManager
    
    public override init() {
        locationManager = CLLocationManager()
        updates = CLLocationUpdate.liveUpdates(.fitness)
        authorizationStatus = locationManager.authorizationStatus
        isBackgroundMode = false
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
        self.backgroundActivity?.invalidate()
        if isBackgroundMode {
            self.backgroundActivity = CLBackgroundActivitySession()
        }
        for try await update in updates {
            isStationary = update.isStationary
            if !isForceStop {
                if !update.isStationary {
                    guard let location = update.location else { return }
                    DispatchQueue.main.async {
                        self.locationHistoryList.append(location)
                        self.latestLocation = location
                        print("getLocation \(location.coordinate.latitude)")
                    }
                } else {
                    isStationary = true
                }
            }
        }
    }
    
    public func stopLocatoin() async throws {
        self.backgroundActivity?.invalidate()
        for try await update in updates {
            break
        }
    }
}

