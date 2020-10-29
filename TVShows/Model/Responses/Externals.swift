import Foundation

struct Externals: Codable {
    
    let tvrage: Int?
    let thetvdb: Int?
    let imdb: String?
    
    init(tvrage: Int?, thetvdb: Int?, imdb: String?) {
        self.tvrage = tvrage
        self.thetvdb = thetvdb
        self.imdb = imdb
    }
    
}
