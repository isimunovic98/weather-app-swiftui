//
//  ErrorVIew.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 17.03.2022..
//

import Foundation

import Foundation
import SwiftUI

struct ErrorView : View {
    
    let error : Error
    
    init(error: Error) {
        self.error = error
    }
    
    var body: some View {
        ZStack {
            Image("body_image-thunderstorm")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 3)
            Text("Error! \(error.localizedDescription)")
                .font(.system(size: 20))
                .padding()
        }
    }
}
