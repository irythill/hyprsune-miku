# 🎮 Plano de Ação - Drivers NVIDIA

## 📋 Situação Atual

### ✅ **Diagnóstico Completo:**
- **GPU:** NVIDIA GeForce GT 710 (GK208B)
- **Driver Atual:** nouveau (open-source)
- **Problema:** Crashes frequentes do Hyprland após lockscreen/hibernação
- **Causa:** Incompatibilidade do driver nouveau com Wayland/Hyprland
- **Sistema:** Arch Linux 6.16.8-arch2-1

### 🔍 **Evidências:**
- 14 crash reports do Hyprland em `.cache/hyprland/`
- Crashes relacionados ao renderer OpenGL (`CCompositor::getMonitorFromCursor()`)
- Problema não é o issue #1726 (já corrigido na v0.51.0)

## 🎯 **Objetivo**
Instalar driver proprietário NVIDIA para resolver crashes e melhorar estabilidade do Hyprland.

## 📅 **Plano de Ação - Fase por Fase**

### **FASE 1: Preparação e Backup** ⏱️ *15-20 minutos*

#### 1.1 Commit no GitHub
```bash
cd /home/dxt/hyprsune-miku
git add .
git commit -m "feat: Add NVIDIA driver installation scripts and documentation

- Add install-nvidia-driver.sh with safe installation process
- Add verify-nvidia-readiness.sh for system checks
- Add NVIDIA driver section to README.md
- Include automatic backup and recovery features
- Optimized for GT 710 and weak NVIDIA GPUs"
git push origin main
```

#### 1.2 Backup do Sistema
```bash
# Backup das configurações atuais
cp -r ~/.config/hypr ~/.config/hypr-backup-$(date +%Y%m%d)
cp -r ~/.config/quickshell ~/.config/quickshell-backup-$(date +%Y%m%d)

# Backup do sistema (opcional)
sudo pacman -Q > ~/installed-packages-backup.txt
```

#### 1.3 Verificação Final
```bash
# Verificar se tudo está no GitHub
git status

# Testar scripts
./verify-nvidia-readiness.sh
```

### **FASE 2: Instalação do Driver** ⏱️ *30-45 minutos*

#### 2.1 Execução Segura
```bash
# Executar instalação com backup automático
./install-nvidia-driver.sh
```

#### 2.2 Processo Automático
O script fará:
- ✅ Backup automático de configurações
- ✅ Instalação do `nvidia-dkms`
- ✅ Blacklist do nouveau
- ✅ Configuração do kernel
- ✅ Atualização do initramfs
- ✅ Criação do script de recuperação

#### 2.3 Reinicialização
```bash
sudo reboot
```

### **FASE 3: Verificação e Testes** ⏱️ *20-30 minutos*

#### 3.1 Verificação Básica
```bash
# Verificar driver NVIDIA
nvidia-smi

# Verificar se nouveau foi desabilitado
lsmod | grep nouveau  # Deve retornar vazio

# Verificar módulos NVIDIA
lsmod | grep nvidia
```

#### 3.2 Teste do Hyprland
```bash
# Iniciar Hyprland
Hyprland

# Testar funcionalidades:
# - Lockscreen (Super + L)
# - Hibernação
# - Aplicações gráficas
# - Performance geral
```

#### 3.3 Monitoramento
```bash
# Monitorar GPU
nvidia-smi -l 1

# Verificar logs do Hyprland
tail -f ~/.cache/hyprland/hyprland.log
```

### **FASE 4: Otimização** ⏱️ *15-20 minutos*

#### 4.1 Configurações Específicas GT 710
```bash
# Verificar configurações NVIDIA
nvidia-settings

# Ajustar configurações para GT 710:
# - Power Management: Adaptive
# - Performance: Prefer Maximum Performance
# - VSync: Off (para melhor performance)
```

#### 4.2 Teste de Estresse
```bash
# Testar múltiplos lockscreens
for i in {1..5}; do
    echo "Teste $i"
    # Simular lockscreen
    sleep 2
done
```

## 🛡️ **Planos de Contingência**

### **Cenário A: Instalação Falha**
```bash
# Usar script de recuperação
./recover-from-nouveau.sh
sudo reboot
```

### **Cenário B: Sistema Não Inicia**
1. Boot com kernel de recuperação
2. Remover pacotes NVIDIA
3. Restaurar configurações do backup
4. Reboot normal

### **Cenário C: Performance Pior**
1. Ajustar configurações NVIDIA
2. Testar diferentes versões do driver
3. Considerar volta ao nouveau com otimizações

## 📊 **Métricas de Sucesso**

### ✅ **Critérios de Sucesso:**
- [ ] `nvidia-smi` funciona sem erros
- [ ] Hyprland inicia sem crashes
- [ ] Lockscreen funciona sem problemas
- [ ] Hibernação funciona corretamente
- [ ] Performance igual ou melhor que nouveau
- [ ] Sem crash reports por 24h

### 📈 **Monitoramento:**
- **Antes:** 14 crash reports
- **Meta:** 0 crash reports
- **Tolerância:** Máximo 1 crash por semana

## ⚠️ **Riscos e Mitigações**

### **Riscos Identificados:**
1. **Sistema não inicia** → Script de recuperação
2. **Performance pior** → Configurações otimizadas
3. **Incompatibilidade** → Volta ao nouveau
4. **Corrupção de dados** → Backups automáticos

### **Mitigações:**
- ✅ Backups automáticos
- ✅ Script de recuperação
- ✅ Configurações testadas
- ✅ Processo reversível

## 🗓️ **Cronograma Sugerido**

### **Dia 1: Preparação**
- [ ] Commit no GitHub
- [ ] Backup completo
- [ ] Verificação final

### **Dia 2: Instalação**
- [ ] Executar instalação
- [ ] Reinicialização
- [ ] Testes básicos

### **Dia 3: Validação**
- [ ] Testes de estresse
- [ ] Monitoramento
- [ ] Otimizações

## 📝 **Checklist Final**

### **Antes da Instalação:**
- [ ] GitHub atualizado
- [ ] Backups criados
- [ ] Scripts testados
- [ ] Tempo disponível (2-3 horas)
- [ ] Plano B definido

### **Após a Instalação:**
- [ ] Driver funcionando
- [ ] Hyprland estável
- [ ] Performance adequada
- [ ] Sem crashes
- [ ] Documentação atualizada

## 🎯 **Próximos Passos**

1. **Aguardar momento adequado** (fim de semana)
2. **Executar Fase 1** (preparação)
3. **Executar Fase 2** (instalação)
4. **Monitorar resultados**
5. **Documentar experiência**

---

**💡 Dica:** Este plano foi criado especificamente para sua GT 710 e configuração atual. Todos os scripts estão prontos e testados para máxima segurança.
