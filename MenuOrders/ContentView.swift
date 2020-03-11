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
                        Button(action: {print("Update Order")}) {
                            Text(order.orderStatus == .pending ? "Prepare" : "Complete")
                                .foregroundColor(.blue)
                        }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        }
    }
}
