//
//  colorDetailScreen.swift
//  SampleColor
//
//  Created by Elizabeth Chiappini on 4/14/20.
//  Copyright © 2020 Mobile Lab. All rights reserved.
//

import SwiftUI

struct colorDetailScreen: View {
    var body: some View {
        VStack {
            Spacer()
            Circle()
            .fill(Color.red)
            .frame(width: 250, height: 250)
            Spacer()
            Text ("Color #")
            Spacer()
        }
    }
}

struct colorDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        colorDetailScreen()
    }
}
