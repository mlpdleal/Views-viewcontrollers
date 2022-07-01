//
//  ContentView.swift
//  InstaFilter
//
//  Created by Manoel Leal on 29/06/22.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

enum FilterType: String{
    case intensity = "Intensity"
    case radius = "Radius"
    case scale = "Scale"
}

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State var sliderText = FilterType.intensity.rawValue
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    @State private var disabledSave = true
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                HStack{
                    Text(sliderText)
                    Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity){ _ in applyProcessing() }
          
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter"){
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(disabledSave)
                    
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("InstaFilter")
            .onChange(of: inputImage){ _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet){
                Group{
                    Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                    Button("Edges") { setFilter(CIFilter.edges()) }
                    Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                    Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                    Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                    Button("Vignette") { setFilter(CIFilter.vignette()) }
                    Button("Comic Effect") { setFilter(CIFilter.comicEffect())   }
                    Button("Gloom") {setFilter(CIFilter.gloom())}
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
        disabledSave = false
    }
    
    func save(){
        guard let processedImage = processedImage else {
            return
        }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)

    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            sliderText = FilterType.intensity.rawValue
        }
        
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
            sliderText = FilterType.radius.rawValue
        }
        
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(filterIntensity * 100, forKey: kCIInputScaleKey)
            sliderText = FilterType.scale.rawValue
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
            
    }
    
    func setFilter(_ filter: CIFilter){
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
