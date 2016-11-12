import Foundation

func readLines(fileURL: URL) -> [String]? {
    do {
        let content = try String(contentsOf: fileURL, encoding: String.Encoding.utf8).components(separatedBy: "\n")
        return content
    }
    catch {
        return nil
    }
}

if let fileURL = Bundle.main.url(forResource: "tokyo-lon-lat", withExtension: "csv"), let coordinates = readLines(fileURL: fileURL) {
    coordinates
    let kml = KML(coordinates: coordinates)
    
    print(kml.xmlString)
}
