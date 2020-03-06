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
                
                Button(action: {
                    print("Save the Order!")
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
