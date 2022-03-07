//
//  ViewProvider.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation
import SwiftUI

class ViewProvider {
    
    func renderErrorView() -> some View {
        return ZStack {
            Image("body_image-thunderstorm")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 3)
            Text("Error!")
                .font(.system(size: 20))
                .padding()
        }
    }
    
    func renderLoadingView(loadingIndicator: Bool) -> some View {
        return ZStack {
            Image("body_image-thunderstorm")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 3)
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color.green, lineWidth: 7)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: loadingIndicator ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
    }
    
}
