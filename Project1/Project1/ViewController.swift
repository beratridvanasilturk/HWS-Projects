//
//  ViewController.swift
//  Project1
//
//  Created by Berat Rıdvan Asiltürk on 10.02.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    
    
    
    
    override func viewDidLoad() {
        
//      SORULACAK
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        //Did load'a bar button item eklememizi saglar, icerigini shareTapped functionunda duzenleyecegiz
        
        
        
        super.viewDidLoad()
        
        title = "StormViewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        //ana ekrandaki title'in buyuk gosterilmesini ve asagi dogru kaydirinca yeniden boyutlanmasini saglar
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                pictures.sort()
                
                // resimlerin isimlerini duzgun siralar
                
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            //secilen fotografi belirler
            vc.selectedPictureNumber = indexPath.row + 1
            //secilen satirin hangisi oldugunu belirler
            vc.totalPicture = pictures.count
            //toplam fotograf sayisini belirler
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
// SORULACAK
//    @objc func shareTapped() {
//
//        let message = UIActivityViewController(activityItems: ["Bu uygulamayi arkadaslarinizla paylasin"], applicationActivities: [])
//        message.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//    }
}
