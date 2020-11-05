import Foundation

class TvShowService {
    
    private let urlBase = "http://api.tvmaze.com/"
    
    public func consulta(callBack: @escaping (Error?, [TvShowRes])->()){
        print("Se buscara lista")
        
        guard let endpoint: URL = URL(string: "\(urlBase)shows") else {
            print("Error formando url")
            return
        }
        
        var request = URLRequest(url: endpoint)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let tarea = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Hubo un error")
                callBack(error!, [])
                return
            }
            
            guard let dataRes = data, let tvShows: [TvShowRes] = try? JSONDecoder().decode([TvShowRes].self, from: dataRes) else {
                print("No se pudo parsear")
                return
            }
            
            DispatchQueue.main.async {
                callBack(nil, tvShows)
            }
            
        }
        tarea.resume()
    }
    
    public func consulta(id: Int, callBack: @escaping (TvShowRes)->()) -> Void {
        print("Se buscara Detalle")
        
        guard let endpoint: URL = URL(string: "\(urlBase)shows/\(id)") else {
            print("Error formando url")
            return
        }
        
        var request = URLRequest(url: endpoint)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let tarea = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Hubo un error")
                print(error!)
                return
            }
            
            guard let dataRes = data, let tvShow: TvShowRes = try? JSONDecoder().decode(TvShowRes.self, from: dataRes) else {
                print("No se pudo parsear \(id)")
                return
            }
            
            DispatchQueue.main.async {
                callBack(tvShow)
            }
            
        }
        tarea.resume()
    }
    
}
