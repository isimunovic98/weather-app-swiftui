//
//  ContentView.swift
//  Shared
//
//  Created by Domagoj Bunoza on 28.02.2022..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            
            Image("body_image-clear-day")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack {
                    Text("TEMPERATURE VALUE")
                        .padding()
                    Text("weather description")
                        .padding()
                }
                Spacer()
                VStack {
                    Text("CITY NAME")
                        .padding()
                    HStack {
                        VStack {
                            Text("low value")
                                .padding()
                            Text("low text")
                        }
                        Divider().frame(maxHeight: 100);
                        VStack {
                            Text("low value")
                                .padding()
                            Text("low text")
                        }
                    }.padding()
                    HStack {
                        Spacer()
                        Spacer()
                        VStack {
                            Image("humidity_icon")
                                .resizable()
                                .scaledToFit()
                                .padding()
                            Text("low text")
                        }
                        VStack {
                            Image("pressure_icon")
                                .resizable()
                                .scaledToFit()
                                .padding()
                            Text("low text")
                        }
                        
                        VStack {
                            Image("wind_icon")
                                .resizable()
                                .scaledToFit()
                                .padding()
                            Text("low text")
                        }
                        Spacer()
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Text("settings").frame(width: UIScreen.main.bounds.width * 0.2)
                        Text("Search bar").frame(width: UIScreen.main.bounds.width * 0.65)
                    }.padding()
                }
                
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
