//
//  Detalle+CoreDataProperties.swift
//  TVShows
//
//  Created by Erwin on 29/10/20.
//  Copyright © 2020 Erwin. All rights reserved.
//
//

import Foundation
import CoreData


extension Detalle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detalle> {
        return NSFetchRequest<Detalle>(entityName: "Detalle")
    }

    @NSManaged public var canal: String?
    @NSManaged public var detalle: String?
    @NSManaged public var duracion: Int16
    @NSManaged public var estatus: String?
    @NSManaged public var generos: String?
    @NSManaged public var id: UUID?
    @NSManaged public var imagen: Data?
    @NSManaged public var language: String?
    @NSManaged public var pais: String?
    @NSManaged public var rating: Double
    @NSManaged public var serie: Series?

}
