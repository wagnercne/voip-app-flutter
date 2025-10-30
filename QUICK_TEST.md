# 🎮 Teste Imediato - Simulação SIP

## 🚀 **Teste Rápido Sem Servidor SIP**

### **1. Testar Interface e Navegação**

Quando o app estiver rodando (`flutter run -d chrome`):

#### **🎨 Tela Principal**
- ✅ Preencher campos:
  ```
  Servidor SIP: wss://demo.example.com
  Usuário: demo_user  
  Senha: demo_pass
  Destino: 1234567890
  ```
- ✅ Pressionar "Registrar / Atualizar"
- ✅ Verificar feedback visual (botões, estados)
- ✅ Testar toggle "Vídeo"

#### **⚙️ Tela de Configurações** 
- ✅ Clicar no ícone de engrenagem (topo direito)
- ✅ Testar sliders de qualidade
- ✅ Mudar codecs nos dropdowns
- ✅ Verificar se salva as configurações
- ✅ Voltar com seta

#### **📋 Histórico de Chamadas**
- ✅ Clicar no ícone de histórico (topo direito)
- ✅ Ver tabs "Todas" e "Perdidas"
- ✅ Verificar mensagem "Nenhuma chamada"
- ✅ Voltar com seta

#### **🔐 Permissões**
- ✅ Clicar "Solicitar Permissões"
- ✅ Permitir microfone no navegador
- ✅ Verificar feedback visual

---

## 📞 **Teste VoIP Real - Servidores Públicos**

### **Opção 1: JsSIP Demo Server**
```
Servidor: wss://tryit.jssip.net
Usuário: <seu_numero>@tryit.jssip.net
Senha: (deixar vazio)
Destino: echo@tryit.jssip.net
```

### **Opção 2: SIP.js Demo**
```
Servidor: wss://sip-ws.example.com
Usuário: demo
Senha: demo123
Destino: *43 (echo test)
```

### **Opção 3: Servidor Local Rápido**
Para teste avançado, você pode usar:
- **Asterisk** com WebSocket
- **FreeSWITCH** com mod_verto
- **Kamailio** + RTPEngine

---

## 🎯 **Fluxo de Teste Completo**

### **1. Inicialização**
```powershell
# Terminal 1: Executar app
flutter run -d chrome

# Terminal 2: Monitorar logs (opcional)
flutter logs
```

### **2. Teste de UI (5 minutos)**
1. ✅ App carrega sem erros
2. ✅ Interface responsiva e bonita
3. ✅ Navegação entre telas funciona
4. ✅ Campos de entrada respondem
5. ✅ Configurações salvam/carregam
6. ✅ Estados visuais corretos

### **3. Teste SIP Básico (10 minutos)**
1. ✅ Inserir servidor de teste
2. ✅ Tentar registro (pode falhar - OK)
3. ✅ Verificar feedback de erro apropriado
4. ✅ Testar diferentes servidores
5. ✅ Verificar logs no console do navegador

### **4. Teste de Chamada (15 minutos)**
Com servidor funcional:
1. ✅ Registro bem-sucedido
2. ✅ Fazer chamada para echo test
3. ✅ Tela de chamada aparece
4. ✅ Controles funcionam (mute, speaker)
5. ✅ Timer funciona
6. ✅ Desligar funciona
7. ✅ Histórico é salvo

---

## 🔧 **Durante o Teste - Hot Reload**

Com o app rodando, você pode:

```
r - hot reload (aplicar mudanças sem reiniciar)
R - hot restart (reiniciar app)
w - abrir DevTools no navegador
q - quit (fechar app)
s - screenshot
```

### **Exemplo de mudança rápida:**
1. Editar cor em `home_page.dart`
2. Salvar arquivo (Ctrl+S)
3. Pressionar `r` no terminal
4. Ver mudança instantânea no navegador

---

## 📊 **Verificações de Qualidade**

### **Console do Navegador (F12)**
Verificar se há:
- ✅ Sem erros JavaScript críticos
- ✅ Logs SIP apropriados
- ✅ WebRTC funcionando
- ⚠️ Warnings são OK (esperados)

### **DevTools Flutter**
Pressionar `w` no terminal para abrir:
- ✅ Widget inspector funcional
- ✅ Performance sem travamentos
- ✅ Network requests aparecem
- ✅ Logs estruturados

---

## 🐛 **Problemas Comuns e Soluções**

### **"Connection failed" no SIP**
```
❌ Problema: Servidor não responde
✅ Solução: Usar servidor público de teste primeiro
✅ Verificar: URL deve começar com wss://
✅ Testar: Ping do servidor separadamente
```

### **WebRTC não funciona**
```
❌ Problema: Áudio/vídeo não funciona
✅ Solução: Permitir microfone no navegador
✅ Verificar: Https/localhost necessário para WebRTC
✅ Testar: Abrir DevTools → Application → Permissions
```

### **Hot reload não aplica mudanças**
```
❌ Problema: Mudanças não aparecem
✅ Solução: Pressionar R (hot restart)
✅ Verificar: Salvar arquivo primeiro (Ctrl+S)
✅ Alternativa: flutter clean && flutter run
```

---

## 📱 **Teste no Emulador Android**

Quando quiser testar permissões reais:

```powershell
# Terminal separado
flutter emulators --launch Medium_Phone_API_36.1

# Aguardar 2-3 minutos para boot, depois:
flutter run
# ou
flutter run -d Medium_Phone_API_36.1
```

**Diferenças no Android:**
- ✅ Permissões nativas (microfone/câmera)
- ✅ WebRTC com melhor performance
- ✅ Notificações reais
- ✅ Background modes
- ✅ UI mobile responsiva

---

## ✅ **Checklist de Teste Rápido**

### **Básico (5 min)**
- [ ] App inicia sem crash
- [ ] Interface carrega corretamente
- [ ] Navegação entre telas funciona
- [ ] Campos de entrada respondem
- [ ] Hot reload funciona

### **Intermediário (15 min)**
- [ ] Configurações salvam/carregam
- [ ] Permissões podem ser solicitadas
- [ ] Estados visuais corretos
- [ ] Sem erros críticos no console
- [ ] DevTools abre e funciona

### **Avançado (30 min)**
- [ ] Conexão SIP funcional
- [ ] Chamadas podem ser feitas
- [ ] Áudio funciona (com servidor)
- [ ] Controles de chamada responsivos
- [ ] Histórico persiste corretamente

---

**🎯 Comando para começar agora**: `flutter run -d chrome` e testar a interface! 📞✨