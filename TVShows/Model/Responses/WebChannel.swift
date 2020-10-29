import Foundation

struct WebChannel: Codable {
    
    let id: Int?
    let name: String?
    let country: Country?
    
    init(id: Int?, name: String?, country: Country?) {
        self.id = id
        self.name = name
        self.country = country
    }
    
}
