PLANNERApp - iOS Görev Yönetimi Sistemi
PLANNERApp, modern mobil uygulama geliştirme standartları kullanılarak inşa edilmiş, ölçeklenebilir ve güvenli bir görev yönetim platformudur. Proje, kullanıcı deneyimini ön planda tutan bir arayüz ile güçlü bir bulut altyapısını birleştirmektedir.

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
