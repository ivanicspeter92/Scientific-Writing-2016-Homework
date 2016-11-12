import Foundation

extension String {
    mutating func removeLastCharacter() {
        self = self.substring(to: self.index(before: self.endIndex))
    }
}
