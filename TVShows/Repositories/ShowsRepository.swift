import UIKit
import CoreData

class ShowsRepository {
    
    public static func consultar() -> Array<NSManagedObject> {
        
        let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entidad: String = "Series"
        let peticion = NSFetchRequest<Series>(entityName: entidad)
        peticion.predicate = NSPredicate(format: "id != nil")
        
        do {
            let resultado = try managedObjectContext.fetch(peticion)
            return resultado
        } catch let error as NSError {
            print(error)
            return []
        }
    }
    
    public static func consultar(id: Int) -> NSManagedObject? {
        let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entidad: String = "Series"
        let peticion = NSFetchRequest<Series>(entityName: entidad)
        peticion.predicate = NSPredicate(format: "id == \(id)")
        
        do {
            let resultado = try managedObjectContext.fetch(peticion)
            guard let result = resultado.first else {
                return nil
            }
            return result
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    public static func guardar(tvShow: TvShowRes) -> Bool {
        guard let id = tvShow.id, let nombre = tvShow.name, let imagen = tvShow.image?.medium, let imagen2 = tvShow.image?.original, let generos = tvShow.genres else {
            return false
        }
        
        var sinopsis = ""
        if let detPeli = tvShow.summary {
            sinopsis = detPeli.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "</b>", with: "")
        } else {
            sinopsis = "unknown"
        }
        
        var generosString = ""
        if generos.count > 0 {
            generos.forEach { i in
                generosString += "\(i) "
            }
        } else {
            generosString = "unknown"
        }
        
        var imdbID: URL? = nil
        if let imdb = tvShow.externals?.imdb {
            imdbID = URL(string: "https://www.imdb.com/title/\(imdb)/")
        }
        
        guard let url = URL(string: imagen) else { return false }
        guard let imgData = try? Data.init(contentsOf: url) else { return false }
        
        guard let url2 = URL(string: imagen2) else { return false }
        guard let imgData2 = try? Data.init(contentsOf: url2) else { return false }
        
        let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let entidad: String = "Series"
        guard let entity = NSEntityDescription.entity(forEntityName: entidad, in: managedObjectContext) else { return false }
        let serie = Series(entity: entity, insertInto: managedObjectContext)
        serie.id = Int16(id)
        serie.name = nombre
        serie.image = imgData
        
        let entidad2: String = "Detalle"
        guard let entity2 = NSEntityDescription.entity(forEntityName: entidad2, in: managedObjectContext) else { return false }
        let detalle = Detalle(entity: entity2, insertInto: managedObjectContext)
        detalle.id = UUID()
        detalle.canal = tvShow.webChannel?.name ?? "unknown"
        detalle.detalle = sinopsis
        detalle.duracion = Int16(tvShow.runtime ?? 0)
        detalle.estatus = tvShow.status ?? "unknown"
        detalle.generos = generosString
        detalle.imagen = imgData2
        detalle.language = tvShow.language ?? "unknown"
        detalle.pais = tvShow.webChannel?.country?.name ?? "unknown"
        detalle.rating = tvShow.rating?.average ?? 10.0
        detalle.imdb = imdbID
        
        detalle.serie = serie

        do {
            try managedObjectContext.save()
            return true
        } catch let error as NSError {
            print(error)
            return false
        }
    }
    
    public static func eliminar(id: Int) -> Bool {
        let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entidad: String = "Series"
        let peticion = NSFetchRequest<Series>(entityName: entidad)
        peticion.predicate = NSPredicate(format: "id == \(id)")
        
        do {
            let resultado = try managedObjectContext.fetch(peticion)
            guard let result = resultado.first else {
                return false
            }
            managedObjectContext.delete(result)
            try managedObjectContext.save()
            return true
        } catch let error as NSError {
            print(error)
            return false
        }
    }
    
}
