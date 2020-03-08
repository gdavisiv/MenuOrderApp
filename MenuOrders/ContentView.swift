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
    //Unfortunately there’s a bug in the current version of SwiftUI. Since we injected into the SceneDelegate’s
    //scene function, the managed object context should be accessible globally by all views by using the
    //corresponding environment property. However, doing this inside popover views like our OrderSheet won’t work
    //properly. What we have to do is to pass the managedObjectContext that gets initialised inside the scene
    //function downwards to our OrderSheet. Thus, we have to use the @Environment property inside our ContentView,
    //too …
    @Environment(\.managedObjectContext) var mangedObjectContext
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
                .sheet(isPresented: $showOrderSheet) {
                    OrderSheet().environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
