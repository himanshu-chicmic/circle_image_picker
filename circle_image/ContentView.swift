
//
//  ContentView.swift
//  Imagelogo
//
//  Created by ChicMic on 03/05/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var image: Image = Image("profile")

    var body: some View {
        
        CustomShapedImagePicker(size: 200, defaultImage: $image, editButtonImage: Image(systemName: "person"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

