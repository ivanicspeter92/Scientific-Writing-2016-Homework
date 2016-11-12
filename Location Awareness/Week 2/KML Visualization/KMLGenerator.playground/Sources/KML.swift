import Foundation

public struct KML {
    // MARK: - Variables
    public var xmlString: String {
        let root = XMLElement(name: KMLTag.root.rawValue)
        let rootAttribute = XMLNode.attribute(withName: "xmlns", stringValue: "http://www.opengis.net/kml/2.2") as! XMLNode
        root.addAttribute(rootAttribute)
        let xml = XMLDocument(rootElement: root)
        let document = XMLElement(name: KMLTag.document.rawValue)
        
        for coordinate in self.coordinates {
            let placemark = XMLElement(name: KMLTag.placemark.rawValue)
            placemark.addChild(XMLElement(name: KMLTag.name.rawValue, stringValue: nil))
            let point = XMLElement(name: KMLTag.point.rawValue)
            
            point.addChild(XMLElement(name: KMLTag.coordinates.rawValue, stringValue: coordinate.description))
            placemark.addChild(point)
            
            document.addChild(placemark)
        }
        root.addChild(document)
        
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + xml.xmlString
    }
    
    public var coordinates = [Coordinates]()
    
    // MARK: - Initializers
//    public init() {
//        
//    }
    
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
}
