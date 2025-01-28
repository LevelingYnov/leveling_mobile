# Projet Flutter : LevelingMobile

Bienvenue dans le projet **LevelingMobile** ! Ce projet est une application Flutter conçue pour fonctionner à la fois sur Android et iOS.

## Prérequis pour Flutter

---

### 1. Installation d'Android Studio
Commencez par installer **Android Studio**, qui est nécessaire pour configurer correctement Flutter. Vous pouvez télécharger Android Studio ici :  
[https://developer.android.com/studio](https://developer.android.com/studio)  

Une fois le téléchargement terminé, lancez l'installateur et suivez les instructions. Bien que nous n'utiliserons pas directement l'IDE d'Android Studio pour le moment, son installation garantit que les outils nécessaires pour Flutter sont correctement configurés.

---

### 2. Installation du SDK Flutter
Téléchargez le **SDK Flutter** en suivant les instructions disponibles ici :  
[https://docs.flutter.dev/get-started/install/windows/mobile#download-then-install-flutter](https://docs.flutter.dev/get-started/install/windows/mobile#download-then-install-flutter)  

- Une fois téléchargé, placez le fichier ZIP dans un emplacement approprié, par exemple :  
  `C:\Users\lbouhlel\`
- Extrayez le contenu du ZIP à cet emplacement. Par exemple, vous obtiendrez :  
  `C:\Users\lbouhlel\flutter\bin`

Ensuite, ajoutez ce chemin (`C:\Users\lbouhlel\flutter\bin`) à la **variable d'environnement PATH** de votre système. Cela permettra à votre terminal de reconnaître les commandes Flutter.

---

### 3. Configuration dans Visual Studio Code
Ouvrez **Visual Studio Code** et vérifiez que Flutter est correctement configuré :  
- Utilisez la commande : `Ctrl + Shift + P` (ou `Cmd + Shift + P` sur macOS) pour ouvrir le panneau de commande.  
- Recherchez et testez les commandes Flutter, telles que la création d'un nouveau projet.  

Si la commande de création de projet fonctionne correctement, cela signifie que Flutter est bien installé et prêt à être utilisé. Félicitations !

---

### 4. Configuration du SDK si nécessaire

1. **Vérifiez les composants SDK dans Android Studio**  
   - Ouvrez **Android Studio** et accédez à :  
     **Projects -> More Actions -> SDK Manager**  
   - Assurez-vous que tous les composants nécessaires du SDK sont installés, tels que :  
     - **SDK Platform** (par exemple, Android 33 ou une version compatible avec votre projet).  
     - **SDK Tools**, y compris **platform-tools** et **build-tools**.

2. **Effectuez les mises à jour**  
   - Si des mises à jour sont disponibles, installez-les pour garantir que vous disposez des versions les plus récentes.

3. **Problèmes de licences Android**  
   Si des problèmes de licences Android sont signalés :
   - Supprimez le dossier des licences, qui se trouve par défaut à l'emplacement suivant :  
     ```bash
     C:\Users\lbouhlel\AppData\Local\Android\Sdk\licenses
     ```
   - Ensuite, exécutez la commande suivante dans un terminal pour regénérer les licences et les accepter une par une :  
     ```bash
     flutter doctor --android-licenses
     ```

4. **Vérifiez votre configuration Flutter**  
   Une fois les étapes ci-dessus terminées, exécutez la commande suivante pour vérifier si tout est correctement configuré :  
   ```bash
   flutter doctor
   ```  
   Si d'autres problèmes sont signalés, suivez les instructions affichées pour les résoudre.

---

### 5. Si des problèmes surviennent avec Visual Studio Build Tools  
1. **Lancez Visual Studio Installer**  
   - Recherchez **Visual Studio Installer** dans le menu Démarrer de Windows.  
   - Ouvrez-le pour vérifier l’état de votre installation.  

2. **Effectuez les mises à jour**  
   - Si des mises à jour sont disponibles pour Visual Studio Build Tools, installez-les en cliquant sur **Mettre à jour** ou elle sont installer automatiquement.  

3. **Vérifiez la configuration avec Flutter**  
   - Une fois que l'installation ou la mise à jour est terminée, exécutez :  
     ```bash
     flutter doctor
     ```  
   - Assurez-vous que Visual Studio Build Tools est correctement configuré. Si d'autres erreurs sont signalées, suivez les recommandations de Flutter pour les résoudre.

---

### **6. Lancement du projet**

Pour lancer le projet, vous avez deux options : utiliser un émulateur via Android Studio ou utiliser votre propre smartphone.

#### **Première option : Utiliser l'émulateur**
1. Lancez Android Studio, puis ouvrez le **Virtual Device Manager** via **More Actions** -> **Virtual Device Manager**.
2. Sélectionnez l'appareil virtuel que vous souhaitez émuler.
3. Lancez l'émulateur. Veuillez noter que l'émulation d'un appareil peut ralentir les performances de votre PC, en fonction de la configuration de votre machine.

#### **Deuxième option : Utiliser votre propre appareil**
1. Activez le **mode développeur** sur votre téléphone :
   - Allez dans **Paramètres > À propos du téléphone > Numéro de build** et appuyez 7 fois pour activer le mode développeur.
2. Activez le **débogage USB** dans les **Options pour les développeurs**.
3. Connectez votre téléphone à votre PC via USB.
4. Vérifiez que votre appareil est bien détecté en exécutant la commande suivante dans le terminal :
   ```bash
   flutter devices
   ```
   Si votre appareil apparaît, cela signifie qu'il est correctement configuré et prêt à l'emploi. Vous devrez peut-être installer ou mettre à jour certains pilotes pour que l'application fonctionne correctement sur votre téléphone.

#### **Lancer le projet**
1. **Pour l'émulateur** : Exécutez la commande suivante dans le terminal :
   ```bash
   flutter run
   ```
   L'application sera lancée directement sur l'émulateur.

2. **Pour un appareil physique** :
   - Récupérez l'ID de votre appareil en exécutant :
     ```bash
     flutter devices
     ```
   - Ensuite, lancez le projet avec cette commande :
     ```bash
     flutter run -d <id-de-votre-device>
     ```

Une fois l'application lancée, vous verrez une URL dans votre terminal, par exemple :
```
http://127.0.0.1:9100?uri=http://127.0.0.1:49700/HucHxB_t7Z8=/
```
Cette URL permet de démarrer l'application soit sur l'émulateur, soit sur votre smartphone.

---
