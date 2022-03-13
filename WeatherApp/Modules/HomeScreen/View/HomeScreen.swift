//
//  ContentView.swift
//  Shared
//
//  Created by Domagoj Bunoza on 28.02.2022..
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel : HomeScreenViewModel
    @State private var searchText = ""
    
    let screenHeight = UIScreen.main.bounds.height
    
    let viewProvider : ViewProvider
    
    init(viewmodel : HomeScreenViewModel, viewProvider : ViewProvider) {
        self.viewModel = viewmodel
        self.viewProvider = viewProvider
    }
    
    var body: some View {
        NavigationView {
            if let error = viewModel.error {
                viewProvider.renderErrorView(error: error)
            } else {
                renderContentView()
                    .onAppear(perform: { viewModel.onAppear() })
            }
        }
    }
    
    func renderContentView() -> some View {
        ZStack{
            if viewModel.isLoading {
                viewProvider.renderLoadingView(loadingIndicator: viewModel.isLoading)
            } else {
                ZStack {
                    renderBackgroundImage()
                    VStack {
                        Spacer()
                        renderCurrentWeatherInfo()
                        VStack {
                            renderCityName()
                            renderHighLowTemperature()
                            renderFeatures()
                            renderFooter()
                        }
                    }
                }.navigationViewStyle(.stack)
            }}
    }
    
    func renderBackgroundImage() -> some View {
        return Image(viewModel.screenData.backgroundImage)
            .resizable()
            .ignoresSafeArea()
    }
    
    func renderCurrentWeatherInfo() -> some View {
        return VStack {
            Text(String(viewModel.screenData.currentTemperature))
                .font(.system(size: screenHeight/12).bold())
                .foregroundColor(.white)
                .padding()
            Text(viewModel.screenData.weatherDescription)
                .font(.system(size: screenHeight/30).bold())
                .foregroundColor(.white)
                .padding()
        }
    }
    
    func renderCityName() -> some View {
        return Text(viewModel.screenData.cityName)
            .foregroundColor(.white)
            .font(.system(size: screenHeight/35).bold())
            .padding()
    }
    
    func renderHighLowTemperature() -> some View {
        return HStack {
            VStack {
                Text(String(viewModel.screenData.lowTemperature))
                    .foregroundColor(.white)
                    .font(.system(size: screenHeight/30))
                    .padding(EdgeInsets(top: screenHeight/40, leading: 0, bottom: screenHeight/1000, trailing: 0))
                Text("Low")
                    .foregroundColor(.white)
            }
            .padding(.trailing)
            VStack {
                Text(String(viewModel.screenData.highTemperature))
                    .foregroundColor(.white)
                    .font(.system(size: screenHeight/30))
                    .padding(EdgeInsets(top: screenHeight/40, leading: 0, bottom: screenHeight/1000, trailing: 0))
                Text("High")
                    .foregroundColor(.white)
            }
            .padding(.leading)
        }.padding(.bottom)
    }
    
    func renderFeatures() -> some View {
        return HStack {
            renderHumidity()
            renderPressure()
            renderWind()
        }
        .padding(.horizontal)
    }
    
    func renderHumidity() -> some View {
        HStack {
            if viewModel.screenData.showHumidity == true {
                VStack {
                    Image("humidity_icon")
                        .padding(.top)
                        .scaledToFit()
                    Text(String(viewModel.screenData.humidity))
                        .font(.system(size: screenHeight/45))
                        .foregroundColor(.white)
                }.padding(.horizontal)
            }
        }
    }
    
    func renderPressure() -> some View {
        HStack {
            if viewModel.screenData.showPressure == true {
                VStack {
                    Image("pressure_icon")
                        .padding(.top)
                        .scaledToFit()
                    Text(String(viewModel.screenData.pressure))
                        .font(.system(size: screenHeight/45))
                        .foregroundColor(.white)
                }.padding(.horizontal)
            }
        }
    }
    
    func renderWind() -> some View {
        HStack {
            if viewModel.screenData.showWindSpeed == true {
                VStack {
                    Image("wind_icon")
                        .padding(.top)
                        .scaledToFit()
                    Text(String(viewModel.screenData.windSpeed))
                        .font(.system(size: screenHeight/45))
                        .foregroundColor(.white)
                }.padding(.horizontal)
            }
        }
    }
    
    func renderFooter() -> some View {
        let locationRepository = LocationRepositoryImpl()
        let searchScreenViewModel = SearchScreenViewModel(repository: locationRepository)
        
        return HStack {
            NavigationLink(destination: SettingsScreen(backgroundImage: viewModel.screenData.backgroundImage)) {
                Image(systemName: "slider.vertical.3")
                    .resizable()
                    .foregroundColor(.white)
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1)
            }
            NavigationLink (
                destination: SearchView (
                    backgroundImage: viewModel.screenData.backgroundImage,
                    viewModel: searchScreenViewModel)
            ) {
                SearchBarDummy()
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let weatherRepository = WeatherRepositoryImpl()
        let viewProvider = ViewProvider()
        let homeScreenViewModel = HomeScreenViewModel(repository: weatherRepository)
        
        HomeScreen(viewmodel: homeScreenViewModel, viewProvider: viewProvider)
    }
}
