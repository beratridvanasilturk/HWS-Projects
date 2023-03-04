//
//  ViewController.swift
//  Project4
//
//  Created by Berat Rıdvan Asiltürk on 2.03.2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        ///Bu satır, customView parametresini kullanarak yeni bir UIBarButtonItem oluşturur; bu, UIProgressView'ımızı bir UIBarButtonItem'a sardığımız yerdir, böylece araç çubuğumuza girebilir.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [progressButton, spacer, refresh]
        ///Yani, önce ilerleme görünümü, sonra ortada bir boşluk, ardından sağdaki yenileme düğmesi.
        navigationController?.isToolbarHidden = false
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        ///kendimizi web görünümündeki özelliğin bir gözlemcisi olarak ekliyoruz:
        ///addObserver() yöntemi dört parametre alır: gözlemcinin kim olduğu (gözlemci biziz, bu yüzden self kullanıyoruz), hangi özelliği gözlemlemek istediğimiz (WKWebView'in estimatedProgress özelliğini istiyoruz), hangi değeri istediğimiz (yeni ayarlanan değeri istiyoruz, bu yüzden yenisini istiyoruz) ve bir bağlam değeri.
            ///context daha kolaydır: benzersiz bir değer sağlarsanız, değerin değiştiğine dair bildirim aldığınızda aynı context değeri size geri gönderilir. Bu, çağrılanın sizin gözlemciniz olduğundan emin olmak için bağlamı kontrol etmenizi sağlar.
            ///Uyarı: Daha karmaşık uygulamalarda, addObserver() işlevine yapılan tüm çağrılar, gözlemlemeyi bitirdiğinizde (örneğin, görünüm denetleyicisiyle işiniz bittiğinde) removeObserver() işlevine yapılan bir çağrıyla eşleştirilmelidir.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        //KVO kullanarak bir gözlemci olarak kaydolduktan sonra, observeValue() adlı bir yöntemi uygulamanız gerekir. Bu, gözlemlenen bir değerin ne zaman değiştiğini size söyler.
            ///Bu projede, tek önemsediğimiz keyPath parametresinin estimatedProgress olarak ayarlanıp ayarlanmadığıdır - yani, web görünümünün estimatedProgress değerinin değişip değişmediğidir. Eğer değiştiyse, ilerleme görünümümüzün ilerleme özelliğini yeni estimatedProgress değerine ayarlarız.
            ///Küçük bir not: estimatedProgress bir Double'dır, hatırlayacağınız gibi bu 0,5 veya 0,55555 gibi ondalık sayıları temsil etmenin bir yoludur. Yararsız bir şekilde, UIProgressView'in progress özelliği, ondalık sayıları temsil etmenin başka bir (daha düşük hassasiyetli) yolu olan bir Float'tır. Swift, bir Float'ın içine Double koymanıza izin vermez, bu nedenle Double'dan yeni bir Float oluşturmamız gerekir.
    }
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ///Bu, dizimizdeki her öğe için bir UIAlertAction nesnesi ekleyecektir.
        
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
        
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
        }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            ///"bu URL için bir ana bilgisayar varsa, onu çıkar" diyor - ve host ( "ana bilgisayar" )  ile apple.com gibi "web sitesi alanı" kastediliyor. Not: Bunu dikkatlice açmamız gerekiyor çünkü tüm URL'lerin ana bilgisayarı yok.
            for website in websites {
                if host.contains(website) {
                    ///her güvenli web sitesinin ana bilgisayar adında bir yerde bulunup bulunmadığını görmek için contains() yöntemini kullanırız.
                    decisionHandler(.allow)
                    ///web sitesi bulunursa karar işleyiciyi arayıp olumlu yanıt veririz - yüklemeye izin vermek isteriz.
                    return
                    ///web sitesi bulunduysa, decisionHandler'ı çağırdıktan sonra return ifadesini kullanırız. Bu, "yöntemden şimdi çık" anlamına gelir.
                }
            }
        }
        decisionHandler(.cancel)
        ///Son olarak, ayarlanmış bir ana bilgisayar yoksa veya tüm döngüden geçip hiçbir şey bulamadıysak, karar işleyiciyi olumsuz bir yanıtla çağırırız: yüklemeyi iptal et.
        ///contains() yöntemine kontrol etmesi için bir dize verirsiniz ve contains() ile kullandığınız dizenin içinde bulunursa true değerini döndürür. Proje 1'de hasPrefix() yöntemiyle zaten tanışmıştınız, ancak hasPrefix() burada uygun değildir çünkü güvenli site adımız URL'de herhangi bir yerde görünebilir. Örneğin, slashdot.org mobil cihazlar için m.slashdot.org adresine yönlendirir ve hasPrefix() bu testte başarısız olur
    }
    ///Bu temsilci geri çağrısı, her bir şey olduğunda navigasyonun gerçekleşmesine izin vermek isteyip istemediğimize karar vermemizi sağlar. Sayfanın hangi bölümünün gezinmeyi başlattığını kontrol edebilir, bir bağlantının tıklanması veya bir formun gönderilmesiyle tetiklenip tetiklenmediğini görebilir veya bizim durumumuzda, beğenip beğenmediğimizi görmek için URL'yi kontrol edebiliriz.
    ///Proje 2'de kapanışlardan bahsetmiştim: bir değişken gibi bir fonksiyona aktarabileceğiniz ve daha sonraki bir tarihte çalıştırabileceğiniz kod parçaları. Bu decisionHandler da bir closure, ancak tam tersi - başkasına yürütmesi için bir kod parçası vermek yerine, size veriliyor ve yürütmeniz isteniyor.
    /// Bu decisionHandler değişkenine/fonksiyonuna sahip olmak, kullanıcıya "Bu sayfayı gerçekten yüklemek istiyor musunuz?" şeklinde bir kullanıcı arayüzü gösterebileceğiniz ve bir yanıt aldığınızda closure'u çağırabileceğiniz anlamına gelir.
        ///Bunun zaten karmaşık olduğunu düşünebilirsiniz, ancak korkarım başınızı ağrıtabilecek bir şey daha var. decisionHandler closure'unu hemen çağırabileceğiniz gibi daha sonra da çağırabilirsiniz (belki de kullanıcıya ne yapmak istediğini sorduktan sonra), Swift bunu bir kaçış closure'u olarak kabul eder. Yani, closure mevcut yöntemden kaçma ve daha sonraki bir tarihte kullanılma potansiyeline sahiptir. Biz onu bu şekilde kullanmayacağız, ancak potansiyeli var ve önemli olan da bu.
    ///
    }



//Bir UIToolbar'a veya rightBarButtonItem özelliğine rastgele UIView alt sınıfları ekleyemezsiniz. Bunun yerine, bunları özel bir UIBarButtonItem içine sarmalamanız ve bunu kullanmanız gerekir.

//WKWebView bize estimatedProgress özelliğini kullanarak sayfanın ne kadarının yüklendiğini söylese de, WKNavigationDelegate sistemi bize bu değerin ne zaman değiştiğini söylemez. Bu nedenle, iOS'tan anahtar-değer gözlemleme veya KVO adı verilen güçlü bir teknik kullanarak bunu bize söylemesini isteyeceğiz.

// WKNavigationDelegate bize bu değerin ne zaman değiştiğini söylemez. key-value observing (KVO)     etkili bir şekilde "lütfen Y nesnesinin X özelliği herhangi biri tarafından herhangi bir zamanda değiştirildiğinde bana bildirin" demenizi sağlar.

//Swift, daha önce gördüğünüz #selector anahtar sözcüğü gibi çalışan #keyPath adlı özel bir anahtar sözcüğe sahiptir: derleyicinin kodunuzun doğru olup olmadığını kontrol etmesini sağlar -

//URL'ler Swift'te dize degillerdir. URL'lerin Swift'te URL adı verilen kendi özel veri türleri vardır
