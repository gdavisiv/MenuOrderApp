//
//  ContentView.swift
//  MenuOrders
//
//  Created by user163072 on 3/6/20.
//  Copyright © 2020 George Davis IV. All rights reserved.
//
//https://blckbirds.com/post/core-data-and-swiftui/

import SwiftUI

struct ContentView: View {
    @State var showOrderSheet = false
    var body: some View {
        NavigationView {
            List {
                Text("Sample Order")
            }
            .navigationBarTitle("My Orders")
            .navigationBarItems(trailing: Button(action: {self.showOrderSheet = true}, label:
                {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 32, height: 32, alignment: .center)
            }))
                .sheet(isPresented: $showOrderSheet){
            OrderSheet()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
