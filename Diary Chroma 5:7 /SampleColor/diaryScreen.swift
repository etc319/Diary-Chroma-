//
//  diaryScreen.swift
//  SampleColor
//
//  Created by Elizabeth Chiappini on 4/14/20.
//  Copyright © 2020 Mobile Lab. All rights reserved.
//

import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct Fontstyle: ButtonStyle {
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


struct diaryScreen: View {
    @State private var isActive: Bool = false
    @State var isPresented = false
    @State var presentedColor: UIColor = .gray
    @State var presentedDate: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    @ObservedObject var model: ColorModel
    @Binding var mycolors: [ColorInfo]
    
    let count = 1
    
    var myColorsChunked: [[ColorInfo]] {
        return mycolors.chunked(into: 4)
    }
    
    var trueColorRed: CGFloat {
        let redColor = CGFloat (self.presentedColor.rgba.red)
        print("redColor", redColor)
        let multipliedColor = redColor * 255
        return multipliedColor
    }
    var trueColorGreen: CGFloat {
        let greenColor = CGFloat (self.presentedColor.rgba.green)
        print("greenColor", greenColor)
        let multipliedColor = greenColor * 255
        return multipliedColor
    }
    var trueColorBlue: CGFloat {
        let blueColor = CGFloat (self.presentedColor.rgba.blue)
        print("blueColor", blueColor)
        let multipliedColor = blueColor * 255
        return multipliedColor
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical){
                ZStack{
                    Color(red: 236/255, green: 243/255, blue: 255/255)
                    VStack (alignment: .leading){
                        ForEach(myColorsChunked.indices, id: \.self) { rowIndex in
                            HStack {
                                ForEach(self.myColorsChunked[rowIndex].indices, id: \.self) { columnIndex in
                                    Button(action: {
                                        self.isPresented.toggle()
                                        self.presentedColor = self.myColorsChunked[rowIndex][columnIndex].color
                                        self.presentedDate = self.myColorsChunked[rowIndex][columnIndex].date
                                    }, label: {
                                        Circle()
                                            .fill(Color(self.myColorsChunked[rowIndex][columnIndex].color))
                                            .frame(width: 80, height: 80)})
                                    //   print(self.myColorsChunked[rowIndex][columnIndex].date)
                                } .navigationBarTitle("Your Chroma Diary", displayMode: .inline)
                                    .sheet(isPresented: self.$isPresented, content: {
                                        ZStack{
                                            Color(red: 236/255, green: 243/255, blue: 255/255)
                                            VStack {
                                                Spacer()
                                                
                                                Text("RGB: \(self.trueColorRed, specifier: "%.0f"), \(self.trueColorGreen, specifier: "%.0f"), \(self.trueColorBlue, specifier: "%.0f")")
                                                    .font(.custom("Baskerville", size: 35))
                                                    .foregroundColor(Color(red: 6/255, green: 77/255, blue: 83/255))
                                                    .padding(5)
                                                    .background(Color(red: 225/255, green: 234/255, blue: 251/255))
                                                    .cornerRadius(10.0)
                                                Circle()
                                                    .fill(Color(self.presentedColor))
                                                    .frame(width: 270, height: 257)
                                                Text("Date: \(self.presentedDate.month!)/\(self.presentedDate.day!)")
                                                    .font(.custom("Baskerville", size: 30))
                                                    .foregroundColor(Color(red: 6/255, green: 77/255, blue: 83/255))
                                                    .padding(5)
                                                    .background(Color(red: 225/255, green: 234/255, blue: 251/255))
                                                    .cornerRadius(10.0)
                                                Spacer()
                                            }
                                        }
                                    })
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(" ", displayMode: .inline)
    }
}
//}

//struct diaryScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        diaryScreen()
//    }
//}
