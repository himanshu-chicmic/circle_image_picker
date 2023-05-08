//
//  SwiftUIView.swift
//  CircularImagePicker
//
//  Created by Himanshu on 5/4/23.
//

import SwiftUI
import PhotosUI


/// base view for custom shaped image picker
struct CustomShapedImagePicker: View {
    
    // MARK: - properties
    
    // size of the image picker view
    var size: CGFloat
    
    // binding for image
    @Binding var defaultImage: Image
    
    // photots picker item
    @State private var photosPickerItem: PhotosPickerItem?
    
    // customizations for picker
    
    // border color
    var pickerBorderColor: Color = .blue
    // edit button background color
    var editButtonBackgroundColor: Color = .blue
    // edit button foreground color
    var editButtonForegroundColor: Color = .white
    // edit button image
    var editButtonImage: Image = Image(systemName: "pencil")
    
    // MARK: - body
    
    var body: some View {
        
        ZStack (alignment: .bottomTrailing){
            
            // view for create base view for
            // image picker
            DrawImage(
                image:  defaultImage,
                size:   size,
                color:  pickerBorderColor
            )
            
            // image picker item
            // for selecting image
            PhotosPicker(selection: $photosPickerItem, label: {
                editButtonImage
                    .resizable()
                    .frame(width: size/10, height: size/10)
                    .padding(size/20)
                    .foregroundColor(editButtonForegroundColor)
                    .background(editButtonBackgroundColor)
                    .clipShape(Circle())
                    .padding(size/15)
            })
            .onChange(of: photosPickerItem) { _ in
                Task {
                    if let data = try? await photosPickerItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            withAnimation{
                                defaultImage = Image(uiImage: uiImage)
                            }
                            return
                        }
                    }
                }
            }
        }
    }
}


/// view to draw image picker shape
struct DrawImage: View {
    
    // MARK: - properties
    
    // image shown on view
    var image: Image
    // size of the view
    var size: CGFloat
    
    // color on view
    var color: Color = .blue
    
    // size of image shape
    private var imageShapeSize: CGFloat {
        size + (size/10)
    }
    
    // border spacing
    private var borderspacing: CGFloat {
        size/50
    }
    
    // MARK: - body
    
    var body: some View {
        
        // getting the path for
        // creating required shape
        ImageShape(size: imageShapeSize)
            .fill(color)
            .frame(
                width:  imageShapeSize,
                height: imageShapeSize
            )
            // overlay with image over the main image shape
            // with difference in size of the views
            .overlay {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width:  size,
                        height: size
                    )
                    .clipShape(
                        ImageShape(
                            size:   size,
                            space:  borderspacing
                        )
                    )
            }
    }
}


/// view to create the shape of the picker
struct ImageShape: Shape {
    
    // MARK: - properties
    
    // size of the view
    var size: CGFloat
    // extra space if any
    var space: CGFloat?
    
    // get the center position of the smaller circle
    private var centerPositionPlacement: CGFloat {
        size*0.15
    }
    
    // create path of the shape
    func path(in rect: CGRect) -> Path {
        
        // initiailiz the path
        var path = Path()

        // get radius of the main circle
        let radiusCircle = size / 2
        // get center of the main circle
        let centerCircle = CGPoint(x: radiusCircle, y: radiusCircle)
        
        // get center position of the second smaller circle
        let centerPosition = size - centerPositionPlacement
        
        // get center of the second smaller circle
        let centerMoonArc = CGPoint(x: centerPosition, y: centerPosition)
        // get radius of the second smaller circle
        let radiusMoonArc = radiusCircle / 4
        
        // extraSpace variable
        // use to give off any extra space between borders
        // of two overlapping views
        // by default set to 0.
        var extraSpace: CGFloat = 0
        
        // check if space is not nil
        if let space = space {
            extraSpace = space
        }
        
        // add an arc to create the first main circle
        path.addArc(center: centerCircle, radius: radiusCircle, startAngle: .degrees(62), endAngle: .degrees(25), clockwise: false)
        
        // add an arc to create the second smaller circle
        // the radius offset is set if any extra space is given.
        path.addArc(center: centerMoonArc, radius: radiusMoonArc + extraSpace, startAngle: .degrees(310), endAngle: .degrees(141), clockwise: true)
        
        // return the path
        return path
    }
}

struct CustomShapedImage_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
