//
//  OrderSheet.swift
//  MenuOrders
//
//  Created by user163072 on 3/6/20.
//  Copyright © 2020 George Davis IV. All rights reserved.
//
//https://blckbirds.com/post/core-data-and-swiftui/

import SwiftUI

struct OrderSheet: View {
    //Unfortunately there’s a bug in the current version of SwiftUI. Since we injected into the SceneDelegate’s
    //scene function, the managed object context should be accessible globally by all views by using the
    //corresponding environment property. However, doing this inside popover views like our OrderSheet won’t work
    //properly. What we have to do is to pass the managedObjectContext that gets initialised inside the scene
    //function downwards to our OrderSheet. Thus, we have to use the @Environment property inside our ContentView,
    //too …
    @Environment(\.managedObjectContext) var managedObjectContext
    
    //We want to close the OrderSheet modal view. We can do this by inserting the following environment property
    @Environment (\.presentationMode) var presentationMode
    
    let pizzaTypes = ["G", "J", "Liz", "Chica"]
    
    @State var selectedPizzaIndex = 1
    @State var numberOfSlices = 1
    @State var tableNumber = ""
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Order Details")) {
                    Picker(selection: $selectedPizzaIndex, label: Text("Food Type")) {
                        ForEach(0 ..< pizzaTypes.count) {
                            Text(self.pizzaTypes[$0]).tag($0)
                        }
                    }
                    
                    Stepper("\(numberOfSlices) Orders", value: $numberOfSlices, in: 1...12)
                }
                
                Section(header : Text("Table")) {
                    TextField("Table Number", text: $tableNumber)
                        .keyboardType(.numberPad)
                }
                //create an Order instance inside our “Add order Button”.
                //But first, we want to make sure, that the tableNumber String
                //is not empty by using a guard statement.
                Button(action: {
                    guard self.tableNumber != "" else {return}
                    let newOrder = Order(context: self.managedObjectContext)
                            newOrder.pizzaType = self.pizzaTypes[self.selectedPizzaIndex]
                            newOrder.orderStatus = .pending
                            newOrder.tableNumber = self.tableNumber
                            newOrder.numberOfSlices = Int16(self.numberOfSlices)
                            newOrder.id = UUID()
                    //Try to save the created order, if that fails then we print the following error code
                    do {
                        try self.managedObjectContext.save()
                        print("Order Saved!")
                        //This will close the modal view
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }) {
                    Text("Add Order")
                }.navigationBarTitle("Add Order")
                
            }
        }
    }
}

struct OrderSheet_Previews: PreviewProvider {
    static var previews: some View {
        OrderSheet()
    }
}
