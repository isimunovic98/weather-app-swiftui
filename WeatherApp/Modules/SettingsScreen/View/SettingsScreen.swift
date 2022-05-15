//
//  SettingsScreen.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import SwiftUI
import Combine

struct SettingsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var presenter: SettingsScreenPresenter
    
    let backgroundImage: String
    
    init(backgroundImage: String, presenter: SettingsScreenPresenter) {
        self.backgroundImage = backgroundImage
        self.presenter = presenter
        UITableView.appearance().backgroundColor = .white.withAlphaComponent(0)
    }
    
    var body: some View {
        renderContentView()
            .onAppear(perform: {presenter.onAppear()})
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        
            .toolbar(
                content: {
                    ToolbarItem(placement: .navigationBarLeading)
                    {
                        Button(
                            action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        )
                        {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black)
                        }
                    }
                }
            )
    }
    
    func renderContentView() -> some View {
        ZStack {
            renderBackgroundImage()
            VStack{
                renderLocationHistory()
                renderUnitSelection()
                HStack{
                    Spacer()
                    renderHumidity()
                    Spacer()
                    renderPressure()
                    Spacer()
                    renderWind()
                    Spacer()
                }
            }
        }
    }
    
    func renderBackgroundImage() -> some View {
        return Image(backgroundImage)
            .resizable()
            .ignoresSafeArea()
            .blur(radius: 20)
    }
    
    func renderLocationHistory() -> some View {
        return VStack {
            List {
                Section(
                    content:
                        {
                            ForEach(presenter.settingsData.cities, id: \.self)
                            { city in
                                HStack {
                                    Text(city.name)
                                        .onTapGesture {
                                            presenter.selectedCity(geoItem: city)
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    Spacer()
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .onTapGesture {
                                            presenter.selectedDeleteCity(geoItem: city)
                                        }
                                }
                            }
                            .listRowBackground(Color.white.opacity(0.8))
                        },
                    header:
                        {
                            HStack {
                                Text("History")
                                    .contrast(1)
                                Spacer()
                            }
                        }
                )
            }
        }
    }
    
    func renderUnitSelection() -> some View {
        return RadioButtonGroup(
            items: ["Imperial", "Metric"] ,
            callback: { selected in
                presenter.selectMeasuringUnit(unit: selected)
            },
            selectedId: presenter.settingsData.measuringUnit
        )
        .foregroundColor(.white)
        .padding()
    }
    
    func renderHumidity() -> some View {
        return VStack {
            CheckView(
                isChecked: presenter.settingsData.humidity,
                title: "Humidity",
                action: {
                    presenter.toggleFeature(feature: "humidity")
                }
            )
            Image("humidity_icon")
                .scaledToFit()
                .padding()
        }
    }
    
    func renderPressure() -> some View {
        return VStack {
            CheckView(
                isChecked: presenter.settingsData.pressure,
                title: "Pressure",
                action: {
                    presenter.toggleFeature(feature: "pressure")
                }
            )
            Image("pressure_icon")
                .scaledToFit()
                .padding()
        }
    }
    
    func renderWind() -> some View {
        return VStack {
            CheckView(
                isChecked: presenter.settingsData.wind,
                title: "Wind speed",
                action: {
                    presenter.toggleFeature(feature: "wind")
                }
            )
            Image("wind_icon")
                .padding(.vertical)
                .scaledToFit()
        }
    }
}
