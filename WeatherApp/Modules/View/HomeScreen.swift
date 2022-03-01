//
//  ContentView.swift
//  Shared
//
//  Created by Domagoj Bunoza on 28.02.2022..
//

import SwiftUI
import Combine

struct HomeScreen: View {
    @ObservedObject var viewModel : HomeScreenViewModel
    
    init(viewmodel : HomeScreenViewModel) {
        self.viewModel = viewmodel
    }
    
    @State private var searchText = ""
    
    var body: some View {
        ZStack{
            Image(viewModel.output.screenData.backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack {
                    Text(String(viewModel.output.screenData.currentTemperature))
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .padding()
                    Text(viewModel.output.screenData.weatherDescription)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                }
                VStack {
                    Text(viewModel.output.screenData.cityName)
                        .foregroundColor(.white)
                        .padding()
                    HStack {
                        VStack {
                            Text(String(viewModel.output.screenData.lowTemperature))
                                .foregroundColor(.white)
                                .padding()
                            Text("Low")
                                .foregroundColor(.white)
                        }
                        Divider().frame(maxHeight: 100);
                        VStack {
                            Text(String(viewModel.output.screenData.highTemperature))
                                .foregroundColor(.white)
                                .padding()
                            Text("High")
                                .foregroundColor(.white)
                        }
                    }.padding()
                    HStack {
                        Spacer()
                        VStack {
                            Image("humidity_icon")
                                .scaledToFit()
                                .padding()
                            Text(String(viewModel.output.screenData.humidity))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack {
                            Image("pressure_icon")
                                .scaledToFit()
                                .padding()
                            Text(String(viewModel.output.screenData.pressure))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack {
                            Image("wind_icon")
                                .padding(.top)
                                .scaledToFit()
                            Text(String(viewModel.output.screenData.windSpeed))
                                .foregroundColor(.white)
                                .padding(.top)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        
                        Image("settings_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.125)
                        
                        SearchBar(text: $searchText)
                    }.padding()
                }
            }.onAppear(perform: { viewModel.handleGettingLocation()})
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let repository = Repository()
        let homeScreenViewModel = HomeScreenViewModel(repository: repository)
        
        HomeScreen(viewmodel: homeScreenViewModel)
    }
}
