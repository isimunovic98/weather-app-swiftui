//
//  CheckView.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import SwiftUI

struct CheckView: View {
    
    @State var isChecked: Bool
    
    var title: String
    var action: () -> ()
    
    func toggle() {
        isChecked.toggle()
        action()
    }
    
    var body: some View {
        HStack {
            Button(action: toggle)
            {
                Image(systemName: isChecked ? "checkmark.square": "square")
            }
            Text(title)
                .foregroundColor(.white)
        }
    }
}
