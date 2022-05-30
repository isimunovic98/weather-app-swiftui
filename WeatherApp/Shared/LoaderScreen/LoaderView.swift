//
//  LoaderView.swift
//  WeatherApp
//
//  Created by Domagoj Bunoza on 17.03.2022..
//

import Foundation
import SwiftUI

struct LoaderView: View {
    
    var body: some View {
        ZStack {
            Image("body_image-thunderstorm")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 10)
            ProgressView().progressViewStyle(.circular)
        }
    }
}
