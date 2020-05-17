//
//  ContentView.swift
//  SampleColor
//
//  Created by Nien Lam on 4/14/20.
//  Copyright © 2020 Mobile Lab. All rights reserved.
//

import SwiftUI
import Combine

let KeyForUserDefaults = "MY_DATA_KEY"

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.custom("Baskerville", size: 35))
            .foregroundColor(Color.white)
            .padding()
            //.background(LinearGradient(gradient: Gradient(colors: [Color(red: 242/255, green: 242/255, blue: 242/255), Color.orange]), startPoint: .leading, endPoint: .trailing))
   //         .border(Color(red: 85/255, green: 128/255, blue: 223/255), width: 2)
     //       .cornerRadius(10.0)
            .background(Color(red: 6/255, green: 77/255, blue: 83/255))
            .cornerRadius(10.0)
        
        //.background(Color.gray)
        //.padding()
    }
}

struct ColorInfo: Codable {
    var date: DateComponents
    var color: UIColor {
        get {
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        set {
            red = newValue.rgba.red
            green = newValue.rgba.green
            blue = newValue.rgba.blue
            alpha = newValue.rgba.alpha
        }
    }
    // Do not set these directly.
    var red : CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0
    init(date: DateComponents, color: UIColor) {
        self.date = date
        self.color = color
    }
}


class ColorModel: ObservableObject {
    let sampleColorSignal = PassthroughSubject<CGPoint, Never>()
    @Published var pickedColors: [ColorInfo]
    //  @Published var myDataArray = [MyData]()
    @Published var lastSampledColor = UIColor(red:242/255, green: 248/255, blue: 231/255, alpha: 255/255)
    
    init() {
        pickedColors = []
    }
    
    func getColor(index: Int)-> UIColor {
        return pickedColors[index].color
    }
    
    func saveData() {
        let data = pickedColors.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
        //  print("my saved colors are", data)
        print("last sampled color here", lastSampledColor)
        
    }
    
    func loadData () -> Bool {
        guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
            return false
        }
        pickedColors = encodedData.map { try! JSONDecoder().decode(ColorInfo.self, from: $0) }
        //    print("my loaded colors are", pickedColors)
        return true
    }
    
    func addMessage(msg: String) {
        //   let myData = MyData(msg: msg.isEmpty ? "Empty Message" : msg, date: Date())
        let myData = ColorInfo(date: DateComponents(), color: UIColor())
        pickedColors.append(myData)
        saveData()
    }
}
//.onAppear(perform: {loadData()})

struct ContentView: View {
    @State private var isActive: Bool = false
    @State private var isActiveDiary: Bool = false
    @ObservedObject var model = ColorModel()
    
    var body: some View {
        NavigationView {
            ZStack{
                // Color(red:239/255, green: 100/255, blue: 97/255)
                Color(model.lastSampledColor)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    NavigationLink(destination: colorScreen(model: self.model), isActive: self.$isActive) {
                        Text ("")
                    }
                    Spacer()
                    Button(action: {
                        self.isActive = true
                        
                    }) {
                        Text("Add Color")
                            .edgesIgnoringSafeArea(.all)
                    }.buttonStyle(GradientButtonStyle())
                    
                        .padding()
                    
                    NavigationLink(destination: diaryScreen(model: self.model, mycolors: self.$model.pickedColors), isActive: self.$isActiveDiary)
                    {
                        Text ("")
                    }.onAppear(){
                        let _ = self.model.loadData()
                    }
                    
                    Button(action: {
                        self.isActiveDiary = true
                    }) {
                        Text("My Diary")
                            .edgesIgnoringSafeArea(.all)
                    }.buttonStyle(GradientButtonStyle())
                        .edgesIgnoringSafeArea(.all)
                    Spacer()
                    .padding()
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
