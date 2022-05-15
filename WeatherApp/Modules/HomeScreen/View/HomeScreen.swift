//
//  ContentView.swift
//  Shared
//
//  Created by Domagoj Bunoza on 28.02.2022..
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var presenter: HomeScreenPresenter
    @State private var searchText = ""
    
    let screenHeight = UIScreen.main.bounds.height
    
    init(presenter: HomeScreenPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        NavigationView {
            if let error = presenter.error {
                ErrorView(error: error)
            } else {
                renderContentView()
                    .onAppear {
                        presenter.setupData()
                    }
            }
        }
    }
    
    func renderContentView() -> some View {
        ZStack{
            if presenter.isLoading {
                LoaderView()
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
                }
            }
        }
    }
    
    func renderBackgroundImage() -> some View {
        return Image(presenter.screenData.backgroundImage)
            .resizable()
            .ignoresSafeArea()
    }
    
    func renderCurrentWeatherInfo() -> some View {
        return VStack {
            Text(String(presenter.screenData.currentTemperature))
                .font(.system(size: screenHeight/12).bold())
                .foregroundColor(.white)
                .padding()
            Text(presenter.screenData.weatherDescription)
                .font(.system(size: screenHeight/30).bold())
                .foregroundColor(.white)
                .padding()
        }
    }
    
    func renderCityName() -> some View {
        return Text(presenter.screenData.cityName)
            .foregroundColor(.white)
            .font(.system(size: screenHeight/35).bold())
            .padding()
    }
    
    func renderHighLowTemperature() -> some View {
        return HStack {
            VStack {
                Text(String(presenter.screenData.lowTemperature))
                    .foregroundColor(.white)
                    .font(.system(size: screenHeight/30))
                    .padding(EdgeInsets(top: screenHeight/40, leading: 0, bottom: screenHeight/1000, trailing: 0))
                Text("Low")
                    .foregroundColor(.white)
            }
            .padding(.trailing)
            VStack {
                Text(String(presenter.screenData.highTemperature))
                    .foregroundColor(.white)
                    .font(.system(size: screenHeight/30))
                    .padding(EdgeInsets(top: screenHeight/40, leading: 0, bottom: screenHeight/1000, trailing: 0))
                Text("High")
                    .foregroundColor(.white)
            }
            .padding(.leading)
        }
        .padding(.bottom)
    }
    
    func renderFeatures() -> some View {
        ZStack {
            //            if presenter.isAnyFeatureVisible() {
            HStack {
                renderHumidity()
                renderPressure()
                renderWind()
            }
            .padding(.horizontal)
            //            }
            ZStack {
                Spacer()
                    .frame(minHeight: screenHeight/84, idealHeight: screenHeight/8.4, maxHeight: screenHeight/0.5)
                    .fixedSize()
            }
        }
    }
    
    func renderHumidity() -> some View {
        HStack {
            if presenter.screenData.showHumidity == true {
                VStack {
                    Image("humidity_icon")
                        .padding(.top)
                        .scaledToFit()
                    Text(String(presenter.screenData.humidity))
                        .font(.system(size: screenHeight/45))
                        .foregroundColor(.white)
                }.padding(.horizontal)
            }
        }
    }
    
    func renderPressure() -> some View {
        HStack {
            if presenter.screenData.showPressure == true {
                VStack {
                    Image("pressure_icon")
                        .padding(.top)
                        .scaledToFit()
                    Text(String(presenter.screenData.pressure))
                        .font(.system(size: screenHeight/45))
                        .foregroundColor(.white)
                }.padding(.horizontal)
            }
        }
    }
    
    func renderWind() -> some View {
        HStack {
            if presenter.screenData.showWindSpeed == true {
                VStack {
                    Image("wind_icon")
                        .padding(.top)
                        .scaledToFit()
                    Text(String(presenter.screenData.windSpeed))
                        .font(.system(size: screenHeight/45))
                        .foregroundColor(.white)
                }.padding(.horizontal)
            }
        }
    }
    
    func renderFooter() -> some View {
        return HStack {
            presenter.settingsScreenLinkBuilder(
                backgroundImage: presenter.screenData.backgroundImage
            ) {
                Image(systemName: "slider.vertical.3")
                    .resizable()
                    .foregroundColor(.white)
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1)
            }
            presenter.searchScreenLinkBuilder {
                SearchBarDummy()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let homeScreenRouter = HomeScreenRouter()
        homeScreenRouter.makeHomeScreen()
    }
}
