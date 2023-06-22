//
//  ErrorView.swift
//  APOD
//
//  Created by Pachauri, Ankur on 16/06/23.
//

import SwiftUI

struct ErrorView: View {
    let callback: () -> Void
    
    var body: some View {
        VStack {
            Image("error")
            
            Text("Something went wrong!")
            
            Button("Try again", action: callback)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(callback: { })
    }
}
