PLANNERApp - iOS Görev Yönetimi Sistemi
PLANNERApp, modern mobil uygulama geliştirme standartları kullanılarak inşa edilmiş, ölçeklenebilir ve güvenli bir görev yönetim platformudur. Proje, kullanıcı deneyimini ön planda tutan bir arayüz ile güçlü bir bulut altyapısını birleştirmektedir.
<p align="center">
  <img src="https://github.com/user-attachments/assets/3d88b301-5e84-4263-b91d-debbf9daece9" width="180" alt="Neto App Overview" />
  <img src="https://github.com/user-attachments/assets/37583481-8f3a-4cb9-b837-5760de1796af" width="180" alt="Empty State" />
  <img src="https://github.com/user-attachments/assets/af792207-debe-494c-85ef-ef1b66098a77" width="180" alt="Adding Expense" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/6d524d83-0b9c-42ef-a47b-9dcd157a66ca" width="180" alt="Category Selection" />
  <img src="https://github.com/user-attachments/assets/95de3c64-52d6-4934-96d0-d738d4b75736" width="180" alt="Expense List" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/3761c538-97af-4160-9db9-7ad02f05ed7f" width="180" alt="Dark Mode View" />
</p>
Teknik Mimari ve Özellikler
Kimlik Doğrulama ve Güvenlik Yönetimi

Uygulama, Firebase Authentication altyapısını kullanarak uçtan uca güvenli bir oturum yönetimi sunar. Kayıt sürecinde e-posta doğrulama katmanı eklenerek veri güvenliği ve kullanıcı doğruluğu optimize edilmiştir. RootView katmanı sayesinde oturum durumu dinamik olarak kontrol edilmekte, yetkisiz erişimler engellenmektedir.

Veri Yönetimi ve Kalıcılık

Firebase Firestore: Kullanıcı profil bilgileri ve görev verileri, gerçek zamanlı NoSQL veritabanı olan Firestore üzerinde senkronize edilmektedir.

SwiftData: Uygulama içi yerel veri saklama süreçlerinde Apple'ın en güncel framework'ü olan SwiftData kullanılarak yüksek performanslı veri kalıcılığı sağlanmıştır.

Kullanıcı Arayüzü ve Tasarım Standartları

SwiftUI: Projenin tamamı deklaratif programlama yaklaşımıyla, SwiftUI kullanılarak geliştirilmiştir.

Dinamik Tema Desteği: Dark Mode ve Light Mode uyumluluğu sayesinde kullanıcı tercihine göre adapte olan esnek bir arayüz sunulmaktadır.

Gelişmiş Form Yönetimi: Özel giriş alanları (CustomInputFields) ve güvenli şifre girişleri (CustomSecureField) ile veri giriş süreçleri kullanıcı dostu hale getirilmiştir.

Kullanılan Teknolojiler
Dil: Swift 5.10+

Framework: SwiftUI, SwiftData, Foundation

Backend: Firebase Auth, Firebase Firestore

Mimari Desen: MVVM (Model-View-ViewModel)

Geliştirici Bilgileri
Bu proje Simge Benzer tarafından, temiz kod prensipleri ve modern yazılım mimarileri dikkate alınarak geliştirilmiştir. Projenin amacı, mobil platformlarda karmaşık veri akışlarını ve kullanıcı yetkilendirme süreçlerini profesyonel bir standartta yönetmektir.


