import Foundation

public struct KML {
    // MARK: - Variables
    public var xmlString: String {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + self.xml.xmlString
    }
    
    private let root = XMLElement(name: KMLTag.root.rawValue)
    private let document = XMLElement(name: KMLTag.document.rawValue)
    private let xml: XMLDocument
    
    // MARK: - Initializers
    public init() {
        let rootAttribute = XMLNode.attribute(withName: "xmlns", stringValue: "http://www.opengis.net/kml/2.2") as! XMLNode
        self.root.addAttribute(rootAttribute)
        self.xml = XMLDocument(rootElement: self.root)
        root.addChild(document)
    }
    
    public init(coordinates: [String]) {
        self.init()
        var counter = 1
        
        for coordinate in coordinates where !coordinate.isEmpty {
            self.addPlacemark(name: "#" + counter.description, coordinate: coordinate)
            counter += 1
        }
    }
    
    public func addPlacemark(name: String, coordinate: String) {
        let placemark = XMLElement(name: KMLTag.placemark.rawValue)
        placemark.addChild(XMLElement(name: KMLTag.name.rawValue, stringValue: name))
        let point = XMLElement(name: KMLTag.point.rawValue)
        
        point.addChild(XMLElement(name: KMLTag.coordinates.rawValue, stringValue: coordinate))
        placemark.addChild(point)
        
        self.document.addChild(placemark)
    }
}
