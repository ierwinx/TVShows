import Foundation
import CoreData

extension Serires {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Serires> {
        return NSFetchRequest<Serires>(entityName: "Serires")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var image: Data?
    @NSManaged public var detalle: Detalle?

}
