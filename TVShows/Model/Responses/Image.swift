import Foundation

struct Image: Codable {
    
    let medium: String?
    let original: String?
    
    init(medium: String?, original: String?) {
        self.medium = medium
        self.original = original
    }
    
}
