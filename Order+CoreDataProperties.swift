//
//  Order+CoreDataProperties.swift
//  MenuOrders
//
//  Created by user163072 on 3/6/20.
//  Copyright © 2020 George Davis IV. All rights reserved.
//
//

import Foundation
import CoreData


extension Order: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }
    
    //Removed the Question mark from the string type properties since I don't want them to be optionals
    @NSManaged public var numberOfSlices: Int16
    @NSManaged public var pizzaType: String
    @NSManaged public var status: String
    @NSManaged public var tableNumber: String
    @NSManaged public var id: UUID?
    
    var orderStatus: Status {
        set {status = newValue.rawValue}
        get {Status(rawValue: status) ?? .pending}
    }

}

enum Status: String
{
    case pending = "Pending"
    case preparing = "Preparing"
    case completed = "Completed"
}
