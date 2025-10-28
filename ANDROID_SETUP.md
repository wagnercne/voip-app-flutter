# 🔧 Guia de Configuração do Android SDK para Flutter VoIP

## ✅ Status Atual
- ✅ Estrutura Android/iOS criada
- ✅ Permissões VoIP configuradas
- ✅ Build.gradle otimizado para WebRTC
- ❌ Android SDK não instalado
- ❌ Variáveis de ambiente pendentes

## 📱 1. Instalação do Android Studio

### Download
1. Acesse: https://developer.android.com/studio
2. Baixe o Android Studio para Windows
3. Execute o instalador `.exe`

### Configuração Inicial
1. **Welcome Screen** → "Next"
2. **Install Type** → "Standard" (recomendado)
3. **Verify Settings** → Confirme que inclui:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device
4. **License Agreement** → Aceite todas as licenças
5. **Finish** → Aguarde download (~3GB)

## ⚙️ 2. Configuração das Variáveis de Ambiente

### Automática (Execute como Administrador)
```powershell
# Execute este comando no PowerShell como Administrador
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup_android_sdk.ps1
```

### Manual
1. **Abra Configurações do Sistema:**
   - Windows + R → `sysdm.cpl` → "Variáveis de Ambiente"

2. **Adicione variáveis do usuário:**
   - `ANDROID_HOME` = `C:\Users\%USERNAME%\AppData\Local\Android\Sdk`
   - `ANDROID_SDK_ROOT` = `C:\Users\%USERNAME%\AppData\Local\Android\Sdk`

3. **Edite a variável PATH (usuário):**
   Adicione estas linhas:
   ```
   %ANDROID_HOME%\platform-tools
   %ANDROID_HOME%\tools
   %ANDROID_HOME%\tools\bin
   %ANDROID_HOME%\emulator
   ```

4. **Reinicie o PowerShell/VS Code**

## 📋 3. Instalação do Android SDK

### Via Android Studio
1. **Abra Android Studio**
2. **File** → **Settings** → **Languages & Frameworks** → **Android SDK**
3. **SDK Platforms** (instale):
   - ✅ Android 14.0 (API 34) - recomendado
   - ✅ Android 13.0 (API 33)
   - ✅ Android 12.0 (API 31)
   - ✅ Android 9.0 (API 28) - mínimo para WebRTC

4. **SDK Tools** (verifique se estão instalados):
   - ✅ Android SDK Build-Tools
   - ✅ Android SDK Command-line Tools
   - ✅ Android SDK Platform-Tools
   - ✅ Android Emulator
   - ✅ Google Play services

### Via Command Line
```powershell
# Depois de configurar variáveis de ambiente
sdkmanager --list
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

## 🎯 4. Aceitar Licenças do Android

```powershell
# Execute no terminal do projeto
flutter doctor --android-licenses
# Pressione 'y' para aceitar todas as licenças
```

## 📱 5. Configurar Emulador (Opcional)

### Criar AVD
1. **Android Studio** → **Device Manager**
2. **Create Virtual Device**
3. Escolha um device (ex: Pixel 7)
4. Download system image (API 34 recomendado)
5. **Finish**

### Testar Emulador
```powershell
# Listar emuladores
emulator -list-avds

# Iniciar emulador
emulator -avd <nome_do_avd>
```

## ✅ 6. Verificação Final

```powershell
# Deve mostrar ✅ para Android toolchain
flutter doctor

# Testar compilação Android
flutter build apk --debug

# Executar no emulador/dispositivo
flutter run
```

## 🐛 Solução de Problemas Comuns

### "Unable to locate Android SDK"
- Verifique se as variáveis ANDROID_HOME estão corretas
- Reinicie o terminal/VS Code
- Execute: `flutter config --android-sdk C:\Users\%USERNAME%\AppData\Local\Android\Sdk`

### "Android license status unknown"
- Execute: `flutter doctor --android-licenses`
- Aceite todas as licenças pressionando 'y'

### "Gradle build failed"
- Verifique conexão com internet
- Execute: `flutter clean && flutter pub get`
- Tente: `flutter build apk --verbose`

### Erro de NDK
- Android Studio → SDK Manager → SDK Tools
- Instale "NDK (Side by side)"

## 🚀 Próximos Passos

Após configuração bem-sucedida:
1. Execute `flutter doctor` (deve mostrar ✅ Android)
2. Teste: `flutter run` no emulador/dispositivo
3. O app VoIP estará pronto para desenvolvimento!

## 📞 Configurações Específicas VoIP

### Permissões já configuradas:
- ✅ `RECORD_AUDIO` - Microfone
- ✅ `CAMERA` - Vídeo chamadas  
- ✅ `INTERNET` - Conexão SIP
- ✅ `MODIFY_AUDIO_SETTINGS` - Controles de áudio
- ✅ `WAKE_LOCK` - Manter tela ligada
- ✅ `ACCESS_NETWORK_STATE` - Estado da rede

### Build otimizado para WebRTC:
- ✅ minSdk 23 (Android 6.0+)
- ✅ NDK filters: arm64-v8a, armeabi-v7a, x86_64
- ✅ Hardware acceleration habilitada

---

**🎯 Objetivo:** Ter `flutter doctor` mostrando ✅ para "Android toolchain" e conseguir executar `flutter run` com sucesso!