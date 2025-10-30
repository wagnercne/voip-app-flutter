# 🎮 Tutorial de Teste Prático - VoIP App

## 🚀 **App Está Rodando!**

✅ **Status**: Aplicativo carregando no Chrome...  
✅ **URL**: http://localhost:porta_aleatoria  
✅ **DevTools**: Disponível para debugging

---

## 📱 **Interface do Aplicativo**

Quando o app carregar, você verá:

### **🏠 Tela Principal**
```
┌─────────────────────────────────────┐
│  🏠 VoIP App        ⚙️ 📋 🔐      │
├─────────────────────────────────────┤
│                                     │
│  📡 Servidor SIP                    │
│  [wss://seu-servidor.com         ]  │
│                                     │
│  👤 Usuário                         │
│  [seu_usuario                   ]   │
│                                     │
│  🔑 Senha                           │
│  [sua_senha                     ]   │
│                                     │
│  📞 Destino                         │
│  [numero_destino                ]   │
│                                     │
│  ☐ Vídeo                           │
│                                     │
│  [📞 Ligar]  [🔄 Registrar]         │
│                                     │
│  Status: Desconectado               │
└─────────────────────────────────────┘
```

---

## 🧪 **Teste 1: Interface e Navegação (2 minutos)**

### **✅ Verificar elementos visuais**
1. ✅ **Campos de entrada**: Clique em cada campo, digite algo
2. ✅ **Botões**: Hover sobre botões (devem mudar cor)
3. ✅ **Toggle vídeo**: Clique no checkbox "Vídeo"
4. ✅ **Status**: Deve mostrar "Desconectado" inicialmente

### **✅ Navegação entre telas**
1. **⚙️ Configurações**: Clique no ícone de engrenagem (canto superior direito)
   - Verá sliders de qualidade
   - Dropdowns de codecs
   - Botão voltar (seta)
   
2. **📋 Histórico**: Clique no ícone de lista (canto superior direito)
   - Verá tabs "Todas" e "Perdidas"
   - Mensagem "Nenhuma chamada encontrada"
   - Botão voltar (seta)

3. **🔐 Permissões**: Clique no ícone de escudo
   - Botão "Solicitar Permissões"
   - Permitir microfone quando solicitado

---

## 🧪 **Teste 2: Simulação SIP (5 minutos)**

### **✅ Teste com servidor fictício**
```
Servidor: wss://demo.example.com
Usuário: teste123
Senha: senha123
Destino: *43
```

1. ✅ **Preencher campos** com dados acima
2. ✅ **Pressionar "Registrar"** 
   - Status mudará para "Registrando..."
   - Depois "Erro de conexão" (esperado)
   - Feedback visual apropriado

3. ✅ **Pressionar "Ligar"**
   - Deve mostrar mensagem de erro (usuário não registrado)
   - Comportamento correto!

---

## 🧪 **Teste 3: Servidor Real (10 minutos)**

### **🌍 Servidor público de teste**
```
Servidor: wss://tryit.jssip.net
Usuário: seunumero@tryit.jssip.net  
Senha: (deixar vazio)
Destino: echo@tryit.jssip.net
```

### **📞 Fluxo completo**
1. ✅ **Registro**:
   - Inserir credenciais
   - Pressionar "Registrar"
   - Aguardar status "Registrado" ✅

2. ✅ **Chamada**:
   - Pressionar "Ligar"
   - Tela de chamada deve aparecer
   - Timer começando: 00:00, 00:01, 00:02...

3. ✅ **Controles na chamada**:
   - 🔇 **Mute**: Pressionar para silenciar
   - 📢 **Speaker**: Ativar alto-falante
   - 📞 **Hangup**: Desligar chamada
   - ⏱️ **Timer**: Deve contar tempo

4. ✅ **Após chamada**:
   - Volta para tela principal
   - Histórico salvo automaticamente
   - Verificar em 📋 Histórico

---

## 🧪 **Teste 4: Funcionalidades Avançadas (15 minutos)**

### **🎥 Chamada de vídeo**
1. ✅ **Ativar vídeo**: Marcar checkbox "Vídeo"
2. ✅ **Permissões**: Permitir câmera quando solicitado
3. ✅ **Fazer chamada**: Preview local deve aparecer
4. ✅ **Controles**: Botão vídeo on/off na chamada

### **⚙️ Configurações avançadas**
1. ✅ **Codecs de áudio**: Mudar para OPUS, G.711
2. ✅ **Qualidade**: Testar sliders (áudio 64kbps → 128kbps)
3. ✅ **Salvar**: Configurações devem persistir
4. ✅ **STUN servers**: Adicionar servidor personalizado

### **📋 Histórico detalhado**
1. ✅ **Fazer várias chamadas** (diferentes destinos)
2. ✅ **Verificar histórico**: Deve mostrar todas
3. ✅ **Filtros**: Tab "Perdidas" funcional
4. ✅ **Detalhes**: Data/hora corretas

---

## 🔧 **Durante o Teste - Hot Reload**

### **✨ Modificar código em tempo real**
1. **Abrir arquivo**: `lib/pages/home_page.dart`
2. **Mudar cor**: Linha ~30, trocar `Colors.teal` por `Colors.blue`
3. **Salvar**: Ctrl+S
4. **Hot reload**: Pressionar `r` no terminal
5. **Verificar**: App deve ficar azul instantaneamente!

### **🔧 Comandos no terminal**
```
r - Hot reload (aplicar mudanças)
R - Hot restart (reiniciar app)
w - Abrir DevTools
q - Quit (fechar)
c - Clear screen
```

---

## 📊 **Verificações de Qualidade**

### **🌐 Console do navegador (F12)**
1. ✅ **Sem erros críticos** em JavaScript
2. ✅ **SIP logs** aparecem (connect, register, invite)
3. ✅ **WebRTC logs** para áudio/vídeo
4. ⚠️ **Warnings OK** (são esperados)

### **🛠️ Flutter DevTools**
1. **Pressionar `w`** no terminal
2. ✅ **Widget inspector**: Árvore de widgets
3. ✅ **Performance**: Sem travamentos
4. ✅ **Network**: Requests SIP visíveis
5. ✅ **Logs**: Messages estruturadas

---

## 🎯 **Resultados Esperados**

### **✅ Sucesso total**
- Interface carrega perfeitamente
- Navegação fluída entre telas
- Campos respondem corretamente
- Configurações salvam/carregam
- Hot reload funciona instantaneamente
- SIP conecta com servidor real
- Chamadas funcionam com áudio
- Histórico persiste corretamente
- DevTools abre sem problemas

### **⚠️ Parcial (ainda OK)**
- Interface funciona, SIP falha (servidor indisponível)
- Permissões negadas (recarregar página)
- Hot reload às vezes precisa de restart
- Warnings no console (não impedem funcionamento)

### **❌ Problemas críticos**
- App não carrega (erro de dependências)
- Interface quebrada/não responde
- Travamentos constantes
- Hot reload nunca funciona

---

## 🚀 **Próximos Passos Após Teste**

### **Se tudo funcionou ✅**
```powershell
# Teste no emulador Android
flutter emulators --launch Medium_Phone_API_36.1
flutter run  # Escolher emulador

# Build para produção
flutter build apk --release
flutter build web --release
```

### **Se há problemas 🔧**
```powershell
# Limpar e reconstruir
flutter clean
flutter pub get
flutter run -d chrome

# Verificar dependências
flutter doctor -v
flutter pub deps
```

---

**🎯 Agora teste o app no navegador e veja sua aplicação VoIP profissional funcionando! 📞✨**

**URL do app**: Verifique o terminal para ver a URL local (localhost:porta)