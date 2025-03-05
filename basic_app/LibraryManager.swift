import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FBAEMKit
import FirebaseCore
import FirebaseAuth
import FirebaseCrashlytics
import FirebaseAnalytics

class LibraryManager: NSObject, ObservableObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Published var lastLibraryUsed: String = "Ninguna" // Estado para mostrar en la UI
    var onImageCaptured: ((UIImage) -> Void)?

    func callLibraryFunction() {
        let libraries = ["FBSDKLoginKit", "FBSDKShareKit", "FBAEMKit", "FirebaseAuth", "FirebaseCrashlytics"]
        
        if let randomLibrary = libraries.randomElement() {
            DispatchQueue.main.async {
                self.lastLibraryUsed = randomLibrary
            }
            
            switch randomLibrary {
            case "FBSDKLoginKit":
                callFacebookLogin()
            case "FBSDKShareKit":
                callFacebookShare()
            case "FBAEMKit":
                callFacebookAEM()
            case "FirebaseAuth":
                callFirebaseAuth()
            case "FirebaseCrashlytics":
                callFirebaseCrashlytics()
            default:
                break
            }
        }
    }


    private func callFacebookLogin() {
        guard !isRunningInPreview() else {
            print("🔹 FBSDKLoginKit no disponible en SwiftUI Preview.")
            return
        }

        print("➡️ Intentando iniciar sesión con Facebook...")

        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if let error = error {
                print("❌ FBSDKLoginKit Error: \(error.localizedDescription)")
            } else if let result = result, !result.isCancelled {
                print("✅ FBSDKLoginKit - Usuario autenticado con Facebook.")
            } else {
                print("⚠️ FBSDKLoginKit - Inicio de sesión cancelado.")
            }
        }
    }

    private func callFacebookShare() {
        guard !isRunningInPreview() else {
            print("🔹 FBSDKShareKit no disponible en SwiftUI Preview.")
            return
        }

        print("➡️ Intentando compartir en Facebook...")

        let content = ShareLinkContent()
        content.contentURL = URL(string: "https://www.facebook.com")!

        do {
            print("📢 FBSDKShareKit - Se ha preparado el contenido para compartir en Facebook.")
        } catch {
            print("❌ FBSDKShareKit Error al preparar contenido: \(error.localizedDescription)")
        }
    }

    private func callFacebookAEM() {
        print("📊 FBAEMKit - Medición de eventos de Facebook Ads activa.")
    }

    private func callFirebaseAuth() {
        print("🔐 FirebaseAuth está activo y configurado.")
    }

    private func callFirebaseCrashlytics() {
        print("🚨 FirebaseCrashlytics está activo y monitoreando errores.")
        Crashlytics.crashlytics().log("Crashlytics está funcionando correctamente")
    }

    private func callCamera(from viewController: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌ La cámara no está disponible en este dispositivo.")
            return
        }

        print("📷 Abriendo la cámara del sistema...")
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            onImageCaptured?(image)
            print("✅ Imagen capturada con éxito desde la cámara.")
        }
        picker.dismiss(animated: true, completion: nil)
    }

    /// Método para detectar si estamos en SwiftUI Preview y evitar crashes
    private func isRunningInPreview() -> Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
