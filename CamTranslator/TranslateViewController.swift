//
//  TranslateViewController.swift
//  CamTranslator
//
//  Created by Usman on 12/12/2019.
//  Copyright © 2019 Usman. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var translateLanguage: UILabel!
    @IBOutlet weak var detectedLanguage: UILabel!
    @IBOutlet weak var detectedText: UILabel!
    var targetLanguage: String?
    var detectText: String?
    var translation: String?
    var sourceLanguage: String?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        translatedText.text = translation
        detectedText.text = detectText
        translateLanguage.text = targetLanguage
        detectedLanguage.text = sourceLanguage
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
