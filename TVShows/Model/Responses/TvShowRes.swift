import Foundation

struct TvShowRes: Codable {
    
    let id: Int?
    let url: String?
    let name: String?
    let type: String?
    let language: String?
    let genres: [String]?
    let status: String?
    let runtime: Int?
    let premiered: String?
    let officialSite: String?
    let schedule: Schedule?
    let rating: Rating?
    let weight: Int?
    let network: Network?
    let webChannel: WebChannel?
    let externals: Externals?
    let image: Image?
    let summary: String?
    let updated: Int?
    
    init(id: Int?, url: String?, name: String?, type: String?, language: String?, genres: [String]?, status: String?, runtime: Int?, premiered: String?, officialSite: String?, schedule: Schedule?, rating: Rating?, weight: Int?, network: Network?, webChannel: WebChannel?, externals: Externals?, image: Image?, summary: String?, updated: Int?) {
        
        self.id = id
        self.url = url
        self.name = name
        self.type = type
        self.language = language
        self.genres = genres
        self.status = status
        self.runtime = runtime
        self.premiered = premiered
        self.officialSite = officialSite
        self.schedule = schedule
        self.rating = rating
        self.weight = weight
        self.network = network
        self.webChannel = webChannel
        self.externals = externals
        self.image = image
        self.summary = summary
        self.updated = updated
        
    }
    
}
