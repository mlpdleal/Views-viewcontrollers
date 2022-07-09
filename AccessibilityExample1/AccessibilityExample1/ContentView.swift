//
//  ContentView.swift
//  AccessibilityExample1
//
//  Created by Manoel Leal on 08/07/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Your score is")
            Text("1000")
                .font(.title)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Your socre is 1000")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
