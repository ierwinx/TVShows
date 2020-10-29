import Foundation

struct Schedule: Codable {
    
    let time: String?
    let days: [String]?
    
    init(time: String?, days: [String]?) {
        self.time = time
        self.days = days
    }
    
}
