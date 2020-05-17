//
//  VideoSampleView.swift
//  VideoColorSample
//
//  Created by Nien Lam on 4/27/20.
//  Copyright © 2020 Mobile Lab. All rights reserved.
//

import SwiftUI
import Combine

struct VideoSampleView: UIViewControllerRepresentable {
    //let model: AppModel
    //@ObservedObject var model = ColorModel()
    let model: ColorModel

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> VideoSampleViewController  {
        let viewController = VideoSampleViewController()
        
        model.sampleColorSignal.sink { position in
            if let color =  viewController.getColor(atNormalizedPoint: position) {
                self.model.lastSampledColor = color
            }
        }.store(in: &context.coordinator.subscriptions)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VideoSampleViewController, context: Context) {
    }
    
    class Coordinator: NSObject {
        var parent: VideoSampleView
        var subscriptions = Set<AnyCancellable>()
        
        init(_ parent: VideoSampleView) {
            self.parent = parent
        }
    }
}

