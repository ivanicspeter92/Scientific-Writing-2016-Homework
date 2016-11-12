import Foundation

extension XMLElement {
    func addChildren(_ nodes: [XMLNode]) {
        for node in nodes {
            self.addChild(node)
        }
    }
}
