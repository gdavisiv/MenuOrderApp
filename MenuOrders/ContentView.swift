//
//  ContentView.swift
//  MenuOrders
//
//  Created by George Davis IV on 3/6/20.
//  Copyright © 2020 George Davis IV. All rights reserved.
//
//https://blckbirds.com/post/core-data-and-swiftui/

import SwiftUI

struct ContentView: View {
    //Unfortunately there’s a bug in the current version of SwiftUI. Since we injected into the SceneDelegate’s
    //scene function, the managed object context should be accessible globally by all views by using the
    //corresponding environment property. However, doing this inside popover views like our OrderSheet won’t work
    //properly. What we have to do is to pass the managedObjectContext that gets initialised inside the scene
    //function downwards to our OrderSheet. Thus, we have to use the @Environment property inside our ContentView
    //And also add it below in the .sheet modifier too …
    @Environment(\.managedObjectContext) var managedObjectContext
    
    //
    @FetchRequest(entity: Order.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "status !=%@", Status.completed.rawValue))
    
    var orders: FetchedResults<Order>
    
    @State var showOrderSheet = false
    
    var body: some View {
        NavigationView {
            List {
                //Displays the fetched data inside our list
                //Use the ForEach loop inside the list instead of inserting the orders data set in the list
                ForEach(orders) { order in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(order.pizzaType) - \(order.numberOfSlices) slices")
                                .font(.headline)
                            Text("Table \(order.tableNumber)")
                                .font(.subheadline)
                        }
                        Spacer()
                        //call the updateOrder function from our row’s button with passing the particular order instance:
                        Button(action: {self.updateOrder(order: order)}) {
                            Text(order.orderStatus == .pending ? "Prepare" : "Complete")
                                .foregroundColor(.blue)
                        }
                    }
                }
                //to delete the particular object from the managed object context, and then,
                //since the @FetchRequest will automatically detect that the object was deleted,
                //it will update our ContentView accordingly and remove the row
                //from the table with a nice default animation.
                .onDelete { indexSet in
                    for index in indexSet {
                        self.managedObjectContext.delete(self.orders[index])
                }
            }
        }
            .navigationBarTitle("My Orders")
            .navigationBarItems(trailing: Button(action: {self.showOrderSheet = true}, label:
                {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 32, height: 32, alignment: .center)
            }))
            .sheet(isPresented: $showOrderSheet) {
                    //Pass it to the OrderSheet inside the .sheet modifier:
                    OrderSheet().environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}
    //When the user taps on the button we want to update the status to preparing and
    //the button should read “Complete”. When the user taps again, we want the order’s
    //status to be completed, which causes the @FetchRequest to filter the order out
    func updateOrder(order: Order) {
    let newStatus = order.orderStatus == .pending ? Status.preparing : .completed
        managedObjectContext.performAndWait {
            order.orderStatus = newStatus
    try? managedObjectContext.save()
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        }
    }
}
