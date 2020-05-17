//
//  colorScreen.swift
//  SampleColor
//
//  Created by Elizabeth Chiappini on 4/14/20.
//  Copyright © 2020 Mobile Lab. All rights reserved.
//

import SwiftUI

struct colorScreen: View {
    @State var sampledUIColor: UIColor = .gray
    @ObservedObject var model: ColorModel
    @State private var showingAlert = true
    
    var trueColorRed: CGFloat {
        let redColor = CGFloat (model.lastSampledColor.rgba.red)
        print("redColor", redColor)
        let multipliedColor = redColor * 255
        return multipliedColor
    }
    var trueColorGreen: CGFloat {
        let greenColor = model.lastSampledColor.rgba.green
        print("greenColor", greenColor)
        let multipliedColor = greenColor * 255
        return multipliedColor
    }
    var trueColorBlue: CGFloat {
        let blueColor = model.lastSampledColor.rgba.blue
        print("blueColor", blueColor)
        let multipliedColor = blueColor * 255
        return multipliedColor
    }
    
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        
                        // Spacer()
                        VideoSampleView(model: self.model)
                            .frame(width: geometry.size.width, height: geometry.size.width * 4/3)
                            .background(Color.red)
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged { value in
                                    // Get position of tap.
                                    let tapPosition = value.startLocation
                                    // print("Tap position:", tapPosition)
                                    
                                    let positionNormalized = CGPoint(x: tapPosition.x / geometry.size.width,
                                                                     y: tapPosition.y / (geometry.size.width * 4/3))
                                    
                                    // Send tap position for processing.
                                    self.model.sampleColorSignal.send(positionNormalized)
                                    //print(self.model.sampleColorSignal)
                            })
                        Spacer()
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    VStack {
                        Spacer()
                        
                        Color(self.model.lastSampledColor)
                            .frame(width: 200, height: 100)
                            //  .padding()
                            .onTapGesture(count: 2, perform: {
                                let now = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                                let currentColorInfo = ColorInfo(date: now, color: self.model.lastSampledColor)
                                print(currentColorInfo)
                                self.model.pickedColors.append(currentColorInfo)
                                self.model.saveData()
                            })
                        Text("RGB: \(self.trueColorRed, specifier: "%.0f"), \(self.trueColorGreen, specifier: "%.0f"), \(self.trueColorBlue, specifier: "%.0f")")
//                            .font(.custom("Baskerville", size: 25))
//                            .foregroundColor(Color.white)
//                            .padding(10)
//                            .background(Color(red: 6/255, green: 77/255, blue: 83/255))
//                            .cornerRadius(10.0)
//                            .padding(.bottom)
                        .font(.custom("Baskerville", size: 25))
                         .foregroundColor(Color(red: 6/255, green: 77/255, blue: 83/255))
                         .padding(5)
                         .background(Color(red: 225/255, green: 234/255, blue: 251/255))
                         .cornerRadius(10.0)
                        .padding(.bottom)
                    }
                }
            }.onTapGesture() {
                self.showingAlert = false
            }.alert(isPresented:self.$showingAlert) {
                Alert(title: Text("Double tap color chip to add to your diary!"), message: Text(""), dismissButton: .default(Text("Will Do")))
            }
      
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}


//struct colorScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        colorScreen()
//    }
//}
