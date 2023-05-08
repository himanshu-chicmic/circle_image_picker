//
//  ContentView.swift
//  CircularImagePicker
//
//  Created by Himanshu on 03/05/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    // MARK: - properties
    
    // default image to be shown as
    // a placeholder on image picker
    @State var image: Image = Image("profile")

    // MARK: - body
    
    var body: some View {
        
        // custom shaped image picker
        CustomShapedImagePicker(
            size:               200,
            defaultImage:       $image,
            editButtonImage:    Image(systemName: "person")
        )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

