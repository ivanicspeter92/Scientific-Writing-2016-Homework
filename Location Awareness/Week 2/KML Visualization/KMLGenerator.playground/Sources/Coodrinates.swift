import Foundation

public struct Coordinates {
    // MARK: - Variables
    public let longitude: Double
    public let latitude: Double
    public let altitude: Double?
    
    public var description: String {
        return self.longitude.description + "," + self.latitude.description
    }
    
    //MARK: - Initializers
    public init(longitude: Double, latitute: Double, altitude: Double? = nil) {
        self.longitude = longitude
        self.latitude = latitute
        self.altitude = altitude
    }
    
    public init?(string: String) {
        let coordinatesArray = string.components(separatedBy: ",")
        
        switch coordinatesArray.count {
        case 3:
            if let longitude = coordinatesArray[0].toDouble(), let latitude = coordinatesArray[1].toDouble(), let altitude = coordinatesArray[2].toDouble() {
                self.init(longitude: longitude, latitute: latitude, altitude: altitude)
                return
            }
        case 2:
            if let longitude = coordinatesArray[0].toDouble(), let latitude = coordinatesArray[1].toDouble() {
                self.init(longitude: longitude, latitute: latitude)
                return
            }
        default:
            return nil
        }
        return nil
    }
}
