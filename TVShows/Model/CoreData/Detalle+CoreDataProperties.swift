import Foundation
import CoreData

extension Detalle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detalle> {
        return NSFetchRequest<Detalle>(entityName: "Detalle")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var language: String?
    @NSManaged public var generos: String?
    @NSManaged public var url: URL?
    @NSManaged public var estatus: Bool
    @NSManaged public var duracion: Int16
    @NSManaged public var rating: Double
    @NSManaged public var imagen: URL?
    @NSManaged public var detalle: String?
    @NSManaged public var canal: String?
    @NSManaged public var pais: String?
    @NSManaged public var serie: Serires?

}
