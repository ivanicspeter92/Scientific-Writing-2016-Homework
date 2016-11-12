import Foundation

extension String {
    func toDouble() -> Double? {
        let correctedString = self.replacingOccurrences(of: ",", with: ".");
        return Double(correctedString);
    }
}
