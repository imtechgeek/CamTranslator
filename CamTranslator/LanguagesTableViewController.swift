////
////  LanguagesTableViewController.swift
////  CamTranslator
////
////  Created by Usman on 13/12/2019.
////  Copyright © 2019 Usman. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseMLVision
//import FirebaseMLNLLanguageID
//import FirebaseMLNaturalLanguage
//import FirebaseMLNLTranslate
//
//class LanguagesTableViewController: UITableViewController {
//
//
//    var languages = ["English","French","German","Turkish","Spanish"]
//    var languageEncode = ["en","fr","de","tr","es"]
//
//
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        downloadLanguage()
//
//    }
//
//    // MARK: - Table view data source
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return languages.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
//        cell.textLabel?.text = languages[indexPath.row]
//        return cell
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            }
//    func downloadLanguage(){
//
//        let frModel = TranslateRemoteModel.translateRemoteModel(language: .fr)
//        let localModels = ModelManager.modelManager().downloadedTranslateModels
//        localModels.map
//        // Keep a reference to the download progress so you can check that the model
//        // is available before you use it.
//        let progress = ModelManager.modelManager().download(
//            frModel,
//            conditions: ModelDownloadConditions(
//                allowsCellularAccess: false,
//                allowsBackgroundDownloading: true
//            )
//        )
//        NotificationCenter.default.addObserver(
//            forName: .firebaseMLModelDownloadDidSucceed,
//            object: nil,
//            queue: nil
//        ) { [weak self] notification in
//            guard let strongSelf = self,
//                let userInfo = notification.userInfo,
//                let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue]
//                    as? TranslateRemoteModel,
//                model == frModel
//                else { return }
//
//            let alert = UIAlertController(title: "Model Downloaded Successfully", message: "The model was downloaded and is available on the device", preferredStyle: .alert)
//            self!.present(alert, animated: true, completion: nil)
//        }
//
//        NotificationCenter.default.addObserver(
//            forName: .firebaseMLModelDownloadDidFail,
//            object: nil,
//            queue: nil
//        ) { [weak self] notification in
//            guard let strongSelf = self,
//                let userInfo = notification.userInfo,
//                let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue]
//                    as? TranslateRemoteModel
//                else { return }
//            let error = userInfo[ModelDownloadUserInfoKey.error.rawValue]
//            // ...
//        }
//
//    }
//}
