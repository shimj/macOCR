import Foundation
import CoreImage
import Cocoa
import Vision


//ref https://github.com/nirix/swift-screencapture/blob/master/ScreenCapture/ScreenCapture.swift

func capture(destination: URL) -> URL {
    let destinationPath = destination.path as String
    
    let task = Process()
    task.launchPath = "/usr/sbin/screencapture"
    task.arguments = ["-i", "-r", destinationPath]
    task.launch()
    task.waitUntilExit()
    
    return destination
}


//ref https://github.com/schappim/macOCR/blob/master/ocr/main.swift
var joiner = " "

func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
    let context = CIContext(options: nil)
    if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
        return cgImage
    }
    return nil
}

func recognizeTextHandler(request: VNRequest, error: Error?) {
    guard let observations =
            request.results as? [VNRecognizedTextObservation] else {
        return
    }
    let recognizedStrings = observations.compactMap { observation in
        // Return the string of the top VNRecognizedText instance.
        return observation.topCandidates(1).first?.string
    }
    
    // Process the recognized strings.
    let joined = recognizedStrings.joined(separator: joiner)
    print(joined)
    
    // set the clipboard with the recognized text
    // let pasteboard = NSPasteboard.general
    // pasteboard.declareTypes([.string], owner: nil)
    // pasteboard.setString(joined, forType: .string)
}

func detectText(fileName : URL) -> [CIFeature]? {
    if let ciImage = CIImage(contentsOf: fileName){
        guard let img = convertCIImageToCGImage(inputImage: ciImage) else { return nil}
      
        let requestHandler = VNImageRequestHandler(cgImage: img)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.recognitionLanguages = recognitionLanguages
       
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
}
    return nil
}


var recognitionLanguages = ["en-US"]
var inputURL = URL(fileURLWithPath: "/tmp/temp_screenshot.png")

do {
    let args = CommandLine.arguments
    if args.count >= 2 {
        if args[1] == "en" || args[1] == "en-US" {
            recognitionLanguages = ["en-US"]
        } else if args[1] == "zh" {
            recognitionLanguages = ["zh-Hans","zh-Hant"]
        } else if args[1] == "zh-Hans" {
            recognitionLanguages = ["zh-Hans"]
        } else if args[1] == "zh-Hant" {
            recognitionLanguages = ["zh-Hant"]
        }
    }

    let _ = capture(destination : inputURL)
    if let features = detectText(fileName : inputURL), !features.isEmpty{}
}

exit(EXIT_SUCCESS)
