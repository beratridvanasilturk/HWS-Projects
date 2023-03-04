//
//  DetailViewController.swift
//  Project1
//
//  Created by Berat Rıdvan Asiltürk on 12.02.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    
    var selectedPictureNumber = 0
    //secilen fotograf sayisini tanimlar
    var totalPicture = 0
    //toplam fotograf sayisini tanimlar
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "This image is \(selectedPictureNumber) in the \(totalPicture)"
        
        navigationItem.largeTitleDisplayMode = .never
        // detay ekranindaki baslik boyutunu duzenler
     
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    // 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    // fotograflarin daha rahat gorunmesi icin bosluga tiklandiginda navigation controllerin gizlenip acilmasini saglar
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    // bir onceki ekran olan table view de kullanici goruntulemek istedigi fotografa tiklamak isterken ekranda kaos cikmamasi icin navi controllerin bir ust satirdaki ozelligini kapatir.
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found.")
            return
        }
        ///Görüntü görünümümüzün içinde bir görüntü olabilir ya da olmayabilir, bu yüzden onu güvenli bir şekilde okuyacağız ve JPEG verisine dönüştüreceğiz. Bu, 1.0 (maksimum kalite) ile 0.0 (minimum kalite_ arasında bir değer belirtebileceğiniz bir compressionQuality parametresine sahiptir.
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        ///activity view controller'ın nereye sabitlenmesi gerektiğini soyleriz
        present(vc, animated: true)
        // bu kod satiriyla airdrop ve uygulamalarda fotograf paylasimi yapabilmemize olanak saglar
        
    }
    }
