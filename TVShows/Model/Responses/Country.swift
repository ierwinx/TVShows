import Foundation

struct Country: Codable {
    
    let name: String?
    let code: String?
    let timezone: String?
    
    init(name: String?, code: String?, timezone: String?) {
        self.name = name
        self.code = code
        self.timezone = timezone
    }
    
}
