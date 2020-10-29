import Foundation
import CoreData

extension Series {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Series> {
        return NSFetchRequest<Series>(entityName: "Series")
    }

    @NSManaged public var id: Int16
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var detalle: Detalle?

}
