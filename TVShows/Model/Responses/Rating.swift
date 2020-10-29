import Foundation

struct Rating: Codable {
    
    let average: Double?
    
    init(average: Double?) {
        self.average = average
    }
    
}
