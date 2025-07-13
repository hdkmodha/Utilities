//
//  LocationManager.swift
//  Utilities
//
//  Created by Hardik Modha on 22/03/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    enum LocationPermissionState: Int {
        case none = 0
        case allowed
        case denied
        case notDetermined
    }
    
    static let shared = LocationManager()  // Singleton instance
    
    private let locationManager = CLLocationManager()
    private var locationUpdateHandler: ((CLLocation) -> Void)?
    private var geofenceHandler: ((CLRegion, CLRegionState) -> Void)?
    private var authorizationStatus: ((LocationManager.LocationPermissionState) -> Void)?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    /// Request location permission
    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()  // Required for geofencing & background updates
    }
    
    /// Start updating live location
    func startUpdatingLocation(completion: @escaping (CLLocation) -> Void) {
        locationUpdateHandler = completion
        locationManager.startUpdatingLocation()
    }
    
    /// Stop updating location
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Convert location to human-readable address
    func getAddress(from location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            let address = [
                placemark.name,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ].compactMap { $0 }.joined(separator: ", ")
            completion(address)
        }
    }
    
    /// Add a geofence region
    func addGeofence(at coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, notifyOnEntry: Bool = false, notifyOnExit: Bool = false, completion: @escaping (CLRegion, CLRegionState) -> Void) {
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: identifier)
        region.notifyOnEntry = notifyOnEntry
        region.notifyOnExit = notifyOnExit
        locationManager.startMonitoring(for: region)
        geofenceHandler = completion
    }
    
    /// Remove a geofence region
    func removeGeofence(identifier: String) {
        for region in locationManager.monitoredRegions {
            if region.identifier == identifier {
                locationManager.stopMonitoring(for: region)
            }
        }
    }
    
    // MARK: - CLLocationManager Delegate Methods
    
    /// Live location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationUpdateHandler?(location)
    }
    
    /// Geofence event handler (enter/exit region)
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        geofenceHandler?(region, state)
    }
    
    /// Handle region entry
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered geofence: \(region.identifier)")
        geofenceHandler?(region, .inside)
    }
    
    /// Handle region exit
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited geofence: \(region.identifier)")
        geofenceHandler?(region, .outside)
    }
    
    /// Handle permission changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        var state: LocationPermissionState = .none
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            state = .allowed
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            state = .denied
            print("Location access denied.")
        case .notDetermined:
            state = .notDetermined
            print("Location permission not determined yet.")
        @unknown default:
            break
        }
        self.authorizationStatus?(state)
    }
}
