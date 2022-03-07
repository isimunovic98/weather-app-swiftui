//
//  CheckView.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import SwiftUI

struct CheckView: View {
    @State var isChecked:Bool = false
    var title:String
    func toggle(){isChecked = !isChecked}
    var body: some View {
        HStack{
            Button(action: toggle) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
            }
            Text(title)
        }
    }
}
