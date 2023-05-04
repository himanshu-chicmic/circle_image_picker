//
//  SwiftUIView.swift
//  circle_image
//
//  Created by Himanshu on 5/4/23.
//

import SwiftUI
import PhotosUI

struct CustomShapedImagePicker: View {
    
    var size: CGFloat
    @Binding var defaultImage: Image
    
    @State private var photosPickerItem: PhotosPickerItem?
    
    var pickerBorderColor: Color = .blue
    var editButtonBackgroundColor: Color = .blue
    var editButtonForegroundColor: Color = .white
    
    var editButtonImage: Image = Image(systemName: "pencil")
    
    var body: some View {
        ZStack (alignment: .bottomTrailing){
            
            DrawImage(image: defaultImage, size: size, color: pickerBorderColor)
            
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


struct DrawImage: View {
    
    var image: Image
    var size: CGFloat
    
    var color: Color = .blue
    
    private var imageShapeSize: CGFloat {
        size + (size/10)
    }
    
    private var borderspacing: CGFloat {
        size/50
    }
    
    var body: some View {
        ImageShape(size: imageShapeSize)
            .fill(color)
            .frame(width: imageShapeSize, height: imageShapeSize)
            .overlay {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(ImageShape(size: size, space: borderspacing))
            }
    }
}

struct ImageShape: Shape {
    
    var size: CGFloat
    var space: CGFloat?
    
    private var centerPositionPlacement: CGFloat {
        size*0.15
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let radiusCircle = size / 2
        let centerCircle = CGPoint(x: radiusCircle, y: radiusCircle)
        
        let centerPosition = size - centerPositionPlacement
        
        let centerMoonArc = CGPoint(x: centerPosition, y: centerPosition)
        let radiusMoonArc = radiusCircle / 4
        
        var extraSpace: CGFloat = 0
        
        if let space = space {
            extraSpace = space
        }
        
        path.addArc(center: centerCircle, radius: radiusCircle, startAngle: .degrees(62), endAngle: .degrees(25), clockwise: false)
        
        path.addArc(center: centerMoonArc, radius: radiusMoonArc + extraSpace, startAngle: .degrees(310), endAngle: .degrees(141), clockwise: true)
        
        return path
    }
}
