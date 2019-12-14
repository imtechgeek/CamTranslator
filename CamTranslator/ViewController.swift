//
//  ViewController.swift
//  CamTranslator
//
//  Created by Usman on 09/12/2019.
//  Copyright © 2019 Usman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMLVision
import FirebaseMLNLLanguageID
import FirebaseMLNaturalLanguage
import FirebaseMLNLTranslate



class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    lazy var vision = Vision.vision()
    let localModels = ModelManager.modelManager().downloadedTranslateModels
    var spinner = UIActivityIndicatorView(style: .large)
    let languageId = NaturalLanguage.naturalLanguage().languageIdentification()
    var ciImage: CIImage?
    let imagePicker = UIImagePickerController()
    var languages = ["English","French","German","Turkish","Spanish"]
    var languageEncode = ["en","fr","de","tr","es"]
    var rowNumber: Int?
    var detectedText: String?
    var translatedText: String?
    var sourceLanguage: String?
    var currentVC: UIViewController?
    var progress: Progress?
    
    
    @IBOutlet weak var languageSelector: UIPickerView!
    
    @IBOutlet weak var translate: UIButton!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rowNumber = row
        print(languages[row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languageSelector.delegate = self
        languageSelector.dataSource = self
        translate.layer.cornerRadius = translate.bounds.height / 2
        
        // downloadLanguages()
        
    }
    
    @IBAction func photosTapped(_ sender: UIBarButtonItem) {
        showAttachmentActionSheet(vc: self)
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
    }
    @IBAction func translatePressed(_ sender: UIButton) {
        if let image = imageView.image {
            detectText(image: image)
            
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedimage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let color = UIColor(named: "Color")
        return NSAttributedString(string: languages[row], attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func detectText (image: UIImage) {
        let textDetector = vision.onDeviceTextRecognizer()
        
        let visionImage = VisionImage(image: image)
        
        textDetector.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                // ...
                return
            }
            let resultText = result.text
            self.identifyLanguage(text: resultText)
        }
    }
    func identifyLanguage(text: String){
        languageId.identifyLanguage(for: text) { (languageCode, error) in
            if let error = error {
                print("Failed with error: \(error)")
                return
            }
            if let languageCode = languageCode, languageCode != "und" {
                print("Identified Language: \(languageCode)")
                self.showSpinner()
                self.translateText(text: text, sourceLang: languageCode)
            } else {
                print("No language was identified")
            }
        }
    }
    func translateText(text: String, sourceLang: String){
        detectedText = text
        sourceLanguage = sourceLang
        let options = TranslatorOptions(sourceLanguage: .fromLanguageCode(sourceLang), targetLanguage: .fromLanguageCode(languageEncode[rowNumber ?? 0]))
        let englishGermanTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        englishGermanTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            englishGermanTranslator.translate(text) { translatedText, error in
                guard error == nil, let translatedText = translatedText else { return }
                self.hideSpinner()
                self.translatedText = translatedText
                self.performSegue(withIdentifier: "Translate", sender: self)}
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TranslateViewController{
            destinationVC.targetLanguage = languages[rowNumber ?? 0]
            destinationVC.translation = translatedText
            destinationVC.detectText = detectedText
            let locale =  NSLocale(localeIdentifier: sourceLanguage ?? "en")
            let fullName = locale.localizedString(forLanguageCode: sourceLanguage ?? "en")
            destinationVC.sourceLanguage = fullName
            
        }
    }
    func showAttachmentActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: "Choose Media", message:"Choose a Media Source...", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
            
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
            
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}


