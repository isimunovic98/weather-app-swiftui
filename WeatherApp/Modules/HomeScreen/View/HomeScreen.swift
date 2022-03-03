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
        NavigationView {
        ZStack{
            Image(viewModel.output.screenData.backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                VStack {
                    Text(String(viewModel.output.screenData.temp))
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .padding()
                    Text(viewModel.output.screenData.weatherDescription)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                }
                VStack {
                    Text(viewModel.output.screenData.name)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding()
                    HStack {
                        VStack {
                            Text(String(viewModel.output.screenData.tempMin))
                                .foregroundColor(.white)
                                .padding()
                            Text("Low")
                                .foregroundColor(.white)
                        }
                        Divider().frame(maxHeight: 100);
                        VStack {
                            Text(String(viewModel.output.screenData.tempMax))
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
                            Text(String(viewModel.output.screenData.wind))
                                .foregroundColor(.white)
                                .padding(.top)
                        }
                        Spacer()
                    }
                    .padding()
                    HStack {
                        NavigationLink(destination: SettingsScreen(backgroundImage: viewModel.output.screenData.backgroundImage)) {
                            Image("settings_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.125)
                        }
                        
                        
                        NavigationLink(destination: SearchView(backgroundImage: viewModel.output.screenData.backgroundImage)) {
                            SearchBarDummy()
                        }
                    }.padding()
                }
            }.onAppear(perform: { viewModel.startViewModel()})
        }.navigationViewStyle(.stack)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let repository = Repository()
        let persistence = Database()
        let homeScreenViewModel = HomeScreenViewModel(repository: repository, persistence: persistence)
        
        HomeScreen(viewmodel: homeScreenViewModel)
    }
}
