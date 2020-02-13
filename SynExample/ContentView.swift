//
//  ContentView.swift
//  SynExample
//
//  Created by David Jobe on 2020-02-13.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let client = SynClient()
    
    init() {
        client.performCheck()
    }
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
