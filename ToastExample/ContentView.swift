//
//  ContentView.swift
//  ToastExample
//
//  Created by David Jobe on 2020-09-02.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        Button(action: {
            let toast = Toast(message: "Some long message informing the user about usefull stuff", type: .success)
            toast.show()

        }) {
            Text("Trigger toast!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
