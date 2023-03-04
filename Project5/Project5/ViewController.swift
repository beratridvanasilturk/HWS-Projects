//
//  ViewController.swift
//  Project5
//
//  Created by Berat Rıdvan Asiltürk on 3.03.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        ///isEmpty özelligi, dizi boşsa true değerini döndürür ve allWords.count == 0 yazmaya eşittir. isEmpty kullanmamızın nedeni, string gibi bazı koleksiyon türlerinin boyutlarını içerdikleri tüm öğeleri sayarak hesaplamak zorunda olmalarıdır, bu nedenle count == 0 değerini okumak isEmpty kullanmaktan önemli ölçüde daha yavaş olabilir.
        ///
        func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    ///3. satır ilginç kısımdır: tableView'in reloadData() metodunu çağırır. ViewController sınıfımız UITableViewController'dan geldiği için bu tablo görünümü bize bir özellik olarak verilir ve reloadData() çağrısı onu tekrar numberOfRowsInSection'ı çağırmaya ve cellForRowAt'ı tekrar tekrar çağırmaya zorlar. Tablo görünümümüzde henüz herhangi bir satır bulunmadığından, bu birkaç dakika boyunca hiçbir şey yapmayacaktır. Ancak, yöntem kullanıma hazırdır ve tüm verileri doğru yüklediğimizi kontrol etmemizi sağlar
        
        startGame()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ///addTextField() yöntemi sadece UIAlertController'a düzenlenebilir bir metin giriş alanı ekler
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
            ///geçerli görünüm denetleyicisinin bir yöntemine veya özelliğine yapılan her çağrı, self?.submit()'de olduğu gibi, "self?" ile öneklenmelidir.
        }
        ///Kodumuzda bunu kullanıyoruz: [weak self, weak ac]. Bu, self (geçerli görünüm denetleyicisi) ve ac'nin (UIAlertController'ımız) closure içinde zayıf referanslar olarak yakalanacağını bildirir. Bu, closure'un bunları kullanabileceği, ancak güçlü bir referans döngüsü oluşturmayacağı anlamına gelir, çünkü closure'un ikisine de sahip olmadığını açıkça belirttik. Ancak bu Swift için yeterli değil. Metodumuzun içinde view controller'ımızın submit() metodunu çağırıyoruz. Henüz oluşturmadık, ancak kullanıcının girdiği cevabı alacağını ve oyunda deneyeceğini görebiliyor olmalısınız.
        ac.addAction(submitAction)
        ///addAction() metodu UIAlertController'a bir UIAlertAction eklemek için kullanılır
        present(ac, animated: true)
    }
    
    func submit(_ answer : String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    ///Kelimenin 3 if ten de gecip tamam olduğunu öğrendikten sonra su şeyi yaparız: yeni kelimeyi usedWords dizimize 0 dizininde ekleriz. Bu, "dizinin başına ekle" anlamına gelir ve en yeni sözcüklerin tablo görünümünün en üstünde görüneceği anlamına gelir.
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    ///Sonraki iki şey birbiriyle ilişkilidir: tablo görünümüne yeni bir satır ekleriz. Tablo görünümünün tüm verilerini kullanılan kelimeler dizisinden aldığı düşünüldüğünde, bu garip görünebilir. Sonuçta, kelimeyi usedWords dizisine ekledik, öyleyse neden tablo görünümüne bir şey eklememiz gerekiyor? Cevap animasyon. Dediğim gibi, reloadData() yöntemini çağırıp tablonun tüm satırları tamamen yeniden yüklemesini sağlayabiliriz, ancak bu küçük bir değişiklik için çok fazla ekstra iş anlamına gelir ve ayrıca bir atlamaya neden olur - kelime orada değildi ve şimdi var. Kullanıcıların bunu görsel olarak takip etmesi zor olabilir, bu nedenle insertRows() işlevini kullanarak tablo görünümüne dizide belirli bir yere yeni bir satır yerleştirildiğini söyleyebiliriz, böylece yeni hücrenin görünmesini canlandırabilir. Tahmin edebileceğiniz gibi, bir hücre eklemek her şeyi yeniden yüklemekten çok daha kolaydır!
                    ///İkinci olarak, with parametresi satırın nasıl canlandırılacağını belirtmenizi sağlar. Bir tabloya bir şeyler ekleyip çıkarırken, .automatic değeri "bu değişiklik için standart sistem animasyonu neyse onu yap" anlamına gelir. Bu durumda, "yeni satırı üstten kaydır" anlamına gelir.

                }
            }
        }
    }
    
    func isPossible(word: String) -> Bool {
        return true
    }
    func isOriginal(word: String) -> Bool {
        return true
    }
    func isReal(word: String) -> Bool {
        return true
    }
 }

//UITextField, kullanıcının bir şeyler girebilmesi için klavyeyi gösteren basit bir düzenlenebilir metin kutusudur. AddTextField() yöntemini kullanarak UIAlertController'a tek bir metin alanı ekledik.

//in anahtar sözcüğü önemlidir: ondan önceki her şey kapanışı tanımlar; ondan sonraki her şey kapanıştır. Yani action in, UIAlertAction türünde bir in parametresi kabul ettiği anlamına gelir.

//closure içindeki eylem parametresine herhangi bir referans yapmıyoruz, bu da ona bir isim vermemize gerek olmadığı anlamına geliyor. Swift'te bir parametreyi isimsiz bırakmak için aşağıdaki gibi bir alt çizgi karakteri kullanmanız yeterlidir, orn: _ in gibi

//Swift'e hangi değişkenler için güçlü referanslar istemediğinizi söylemelisiniz. Bu iki yoldan biriyle yapılır: unowned or weak.. Bunlar bir şekilde örtülü olarak  unwrapped optionals (unowned) and regular optionals (weak) eşdeğerdir: zayıf olarak sahip olunan bir referans nil olabilir, bu nedenle onu açmanız veya opsiyonel zincirleme (optional chaining) kullanmanız gerekir; unowned (sahipsiz) bir referans, nil olamayacağını onayladığınız bir referanstır ve bu nedenle açılmasına gerek yoktur, ancak yanılıyorsanız bir sorunla karşılaşırsınız.

//self'in kapanış tarafından zayıf bir şekilde sahiplenildiğini zaten bildirdik, ancak Swift ne yaptığımızı bildiğimizden kesinlikle emin olmamızı istiyor: geçerli görünüm denetleyicisinin bir yöntemine veya özelliğine yapılan her çağrı, self?.submit()'de olduğu gibi, "self?" ile öneklenmelidir. Proje 1'de size benliğin kullanımıyla ilgili iki düşünce tarzı olduğunu söylemiş ve şöyle demiştim: "İlk gruptaki insanlar gerekmedikçe benliği kullanmaktan asla hoşlanmazlar, çünkü gerekli olduğunda gerçekten önemli ve anlamlıdır, bu nedenle gerekli olmadığı yerlerde kullanmak meseleleri karıştırabilir.". Kapanışlarda self'in örtük olarak yakalanması, self kullanımının gerekli ve anlamlı olduğu yerdir: Swift burada bundan kaçınmanıza izin vermez. Self kullanımınızı closure'larla sınırlandırarak, kodunuzda "self" araması yaparak herhangi bir referans döngüsü olup olmadığını kolayca kontrol edebilirsiniz - bakılacak çok fazla şey olmamalı!
