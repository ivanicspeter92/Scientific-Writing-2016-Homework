import Foundation

public struct KML {
    // MARK: - Variables
    public var coordinates = [Coordinates]()
    public var xmlString: String {
        return self.xmlString()
    }
    
    // MARK: - Initializers
    public init(coordinatesStringArray: [String]) {
        for coordinateString in coordinatesStringArray where !coordinateString.isEmpty {
            if let coordinate = Coordinates(string: coordinateString) {
                self.coordinates.append(coordinate)
            }
        }
    }
    
    public init(coordinates: [Coordinates]) {
        self.coordinates = coordinates
    }
    
    // MARK: - Public
    public func xmlString(representation: KMLRepresentation = .markers) -> String {
        let root = XMLElement(name: KMLTag.root.rawValue)
        let rootAttribute = XMLNode.attribute(withName: "xmlns", stringValue: "http://www.opengis.net/kml/2.2") as! XMLNode
        root.addAttribute(rootAttribute)
        let xml = XMLDocument(rootElement: root)
        let document = XMLElement(name: KMLTag.document.rawValue)
        
        switch representation {
        case .line:
            document.addChild(self.pointsAsLineStringPlacemark())
        case .markers:
            document.addChildren(self.pointsAsPlacemarkElements())
        }
        
        root.addChild(document)
        
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + xml.xmlString
    }
    
    // MARK: - Private
    private func pointsAsPlacemarkElements() -> [XMLElement] {
        var placemarks = [XMLElement]()
        
        var counter = 1
        for coordinate in self.coordinates {
            let placemark = XMLElement(name: KMLTag.placemark.rawValue)
            placemark.addChild(XMLElement(name: KMLTag.name.rawValue, stringValue: "#" + counter.description))
            let point = XMLElement(name: KMLTag.point.rawValue)
            
            point.addChild(XMLElement(name: KMLTag.coordinates.rawValue, stringValue: coordinate.description))
            placemark.addChild(point)
            placemarks.append(placemark)
            counter += 1
        }
        
        return placemarks
    }
    
    private func pointsAsLineStringPlacemark() -> XMLElement {
        let placemark = XMLElement(name: KMLTag.placemark.rawValue)
        
        var coordinateString = ""
        for coordinate in self.coordinates {
            coordinateString += coordinate.description + " "
        }
        coordinateString.removeLastCharacter()
        
        let lineString = XMLElement(name: KMLTag.lineString.rawValue)
        lineString.addChild(XMLElement(name: KMLTag.coordinates.rawValue, stringValue: coordinateString))
        placemark.addChild(lineString)
        
        return placemark
    }
}
