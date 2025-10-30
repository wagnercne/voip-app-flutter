# 🧪 Guia Completo de Testes - VoIP Flutter App

## 🎯 Como Testar o Aplicativo VoIP

### ✅ **Status do Ambiente**
- ✅ Flutter SDK instalado e funcionando
- ✅ Android Studio configurado
- ✅ Emulador Android disponível: `Medium_Phone_API_36.1`
- ✅ Chrome Web disponível para testes
- ⚠️ Android licenses pendentes (não impedem testes básicos)

---

## 🚀 **1. Testes Rápidos - Web (Recomendado para início)**

### **Executar no Chrome**
```powershell
# Teste mais rápido - executa no navegador
flutter run -d chrome

# Ou com hot reload ativo
flutter run -d chrome --hot
```

**✨ Vantagens do teste web:**
- ✅ Inicialização rápida (sem emulador)
- ✅ Hot reload instantâneo
- ✅ Debugging fácil com DevTools
- ✅ Testa toda a UI e lógica de negócio
- ⚠️ Limitação: WebRTC pode ter diferenças no browser

---

## 📱 **2. Testes Android - Emulador**

### **Iniciar emulador e executar**
```powershell
# Iniciar emulador Android
flutter emulators --launch Medium_Phone_API_36.1

# Aguardar inicialização (2-3 minutos) e executar
flutter run -d Medium_Phone_API_36.1

# Ou deixar Flutter detectar automaticamente
flutter run
```

**✨ Vantagens do emulador:**
- ✅ Teste real de permissões (microfone/câmera)
- ✅ WebRTC nativo
- ✅ UI responsiva em dispositivo móvel
- ✅ Notificações e background modes
- ⚠️ Mais lento para inicializar

---

## 🔧 **3. Preparação para Testes**

### **Verificar dependências**
```powershell
# Atualizar dependências
flutter pub get

# Verificar problemas
flutter analyze

# Limpar build cache (se necessário)
flutter clean && flutter pub get
```

### **Build de teste**
```powershell
# Verificar se compila sem erros
flutter build web --debug
flutter build apk --debug
```

---

## 🎮 **4. Cenários de Teste**

### **🔗 A. Teste de UI (Sem servidor SIP)**

1. **Tela Principal:**
   - ✅ Campos de entrada responsivos
   - ✅ Botões com feedback visual
   - ✅ Estados de carregamento
   - ✅ Navegação entre telas

2. **Configurações:**
   - ✅ Sliders de qualidade funcionais
   - ✅ Dropdown de codecs
   - ✅ Persistência de configurações
   - ✅ Validação de entrada

3. **Histórico:**
   - ✅ Tabs funcionais (Todas/Perdidas)
   - ✅ Lista vazia com mensagem
   - ✅ Simulação de dados (após chamadas)

### **📞 B. Teste VoIP Completo (Com servidor)**

#### **Opção 1: Servidor SIP Público de Teste**
```
Servidor: wss://tryit.jssip.net
Usuário: seu_numero@tryit.jssip.net
Senha: (deixar vazio)
```

#### **Opção 2: Servidor Local (Asterisk/FreeSWITCH)**
```
Servidor: wss://seu-servidor.com:8089/ws
Usuário: 1001
Senha: sua_senha
```

#### **Fluxo de Teste VoIP:**
1. **Registro SIP:**
   - ✅ Inserir credenciais
   - ✅ Pressionar "Registrar"
   - ✅ Verificar status "Registrado"

2. **Chamada de Voz:**
   - ✅ Inserir número destino
   - ✅ Pressionar "Ligar"
   - ✅ Tela de chamada aparece
   - ✅ Testar controles (mute, speaker)
   - ✅ Desligar funciona

3. **Chamada de Vídeo:**
   - ✅ Ativar "Vídeo"
   - ✅ Solicitar permissões
   - ✅ Preview local aparece
   - ✅ Controles de vídeo funcionam

---

## 🛠️ **5. Debug e Desenvolvimento**

### **Hot Reload durante desenvolvimento**
```powershell
# Executar com hot reload
flutter run -d chrome

# Durante execução:
# r - hot reload
# R - hot restart
# q - quit
# s - screenshot
```

### **Debug com VS Code**
1. Abrir `main.dart`
2. Pressionar `F5` ou "Run and Debug"
3. Escolher dispositivo (Chrome/Android)
4. Colocar breakpoints com `F9`

### **Flutter DevTools**
```powershell
# Abrir DevTools
flutter run -d chrome
# No terminal, pressionar 'w' para abrir DevTools
```

---

## 🔍 **6. Verificação de Permissões**

### **Android (Emulador)**
1. Executar app
2. Tentar fazer chamada
3. Verificar se solicita permissões
4. Conceder microfone/câmera
5. Testar novamente

### **Web (Chrome)**
1. Executar no Chrome
2. Permitir microfone quando solicitado
3. Para vídeo: permitir câmera também
4. Verificar ícone de microfone na aba

---

## 📊 **7. Testes de Performance**

### **Profile mode**
```powershell
# Build otimizado para análise
flutter run --profile -d chrome

# Métricas no DevTools
flutter run --profile -d chrome
# Pressionar 'w' → Performance tab
```

### **Release build**
```powershell
# Android APK release
flutter build apk --release

# Web release
flutter build web --release
```

---

## 🐛 **8. Troubleshooting Comum**

### **"Failed to connect" no SIP**
- ✅ Verificar URL do servidor (wss://)
- ✅ Testar com servidor público primeiro
- ✅ Verificar firewall/proxy
- ✅ Conferir credenciais

### **Permissões negadas**
- ✅ Reiniciar app
- ✅ Verificar configurações do dispositivo
- ✅ Limpar dados do app (Android)
- ✅ Recarregar página (Web)

### **Build errors**
```powershell
# Limpar e reconstruir
flutter clean
flutter pub get
flutter run
```

### **Hot reload não funciona**
- ✅ Salvar arquivo (Ctrl+S)
- ✅ Usar 'R' para hot restart
- ✅ Verificar erros no terminal

---

## 🎯 **9. Sequência de Teste Recomendada**

### **Para desenvolvimento rápido:**
1. `flutter run -d chrome` (teste web)
2. Verificar UI e navegação
3. Testar com servidor SIP público
4. Debug no DevTools se necessário

### **Para teste completo:**
1. `flutter emulators --launch Medium_Phone_API_36.1`
2. `flutter run` (emulador Android)
3. Testar permissões nativas
4. Verificar WebRTC real
5. Testar notificações e background

### **Para deploy:**
1. `flutter analyze` (verificar código)
2. `flutter build apk --release`
3. Instalar APK em dispositivo real
4. Teste final com servidor produção

---

## 📱 **10. Teste em Dispositivo Real**

### **Android via USB**
1. Ativar "Depuração USB" no dispositivo
2. Conectar via USB
3. `flutter devices` (deve aparecer o dispositivo)
4. `flutter run -d <device_id>`

### **Via Wireless (Android 11+)**
1. Conectar via USB primeiro
2. `adb tcpip 5555`
3. `adb connect <ip_dispositivo>:5555`
4. Desconectar USB e testar

---

## ✅ **Comandos Rápidos de Teste**

```powershell
# Teste web imediato
flutter run -d chrome

# Teste Android emulador
flutter emulators --launch Medium_Phone_API_36.1
flutter run

# Verificar qualidade do código
flutter analyze

# Build para produção
flutter build apk --release
flutter build web --release

# Limpar cache se houver problemas
flutter clean && flutter pub get
```

---

**🎯 Recomendação**: Comece com `flutter run -d chrome` para teste rápido da UI, depois teste no emulador Android para funcionalidades completas! 📞✨