## DC Motor PID Control with MATLAB/Simulink

Bu proje, DC motorun PID denetleyicisi ile adım cevabının (step response) MATLAB/Simulink ortamında incelenmesini amaçlamaktadır.  

PID parametreleri değiştirildiğinde motorun dinamik cevabı (geçici rejim, kararlı durum, aşım, yerleşme zamanı vb.) gözlemlenebilir.

---

## 📂 Proje Yapısı

dc-motor-pid/

│

├── src/ # Yardımcı MATLAB kodları

├── dc\_motor\_pid.m # Ana MATLAB dosyası (step response \& grafikler)

├── dc\_motor\_pid\_manual.slx # Simulink modeli

├── LICENSE.txt # MIT Lisansı

├── README.md # Bu dosya

└── .gitignore # Gereksiz dosyaları hariç tutar


---


## Çalıştırma

Projeyi çalıştırmak için:

1. MATLAB’i açın.

2. Bu klasörü çalışma dizini olarak seçin.

3. Ana kodu çalıştırın:

 ```matlab

 run('dc\_motor\_pid.m')

4. Çalıştırma sonucunda step response grafiği ve PID performans metrikleri (Peak, Rise Time, Settling Time, Steady State Error vb.) görüntülenecektir.


---


## Örnek Sonuç

Adım cevabı grafiğinde PID metrikleri işaretlenmiştir:

🔴 Peak (tepe değer)

🔵 Rise Time (yükselme zamanı)

🟢 Settling Time (yerleşme zamanı)

🟣 Recovery (sönümleme)

⚫ Steady State (kararlı durum)

%2 bandı (kararlı duruma giriş toleransı)

--- 

## Kullanım Alanları

DC motor kontrol tasarımları

PID parametre optimizasyonu

MATLAB/Simulink proje örneği


---

## Lisans

Bu proje MIT Lisansı altında sunulmaktadır.

Özgürce kullanılabilir, değiştirilebilir ve paylaşılabilir.



MIT License

Copyright (c) 2025 [Gülfem Dayanan]

--- 

## Katkı

Projeyi fork’layabilir veya pull request gönderebilirsiniz.

Önerileriniz ve geliştirmeleriniz için issue açabilirsiniz.







