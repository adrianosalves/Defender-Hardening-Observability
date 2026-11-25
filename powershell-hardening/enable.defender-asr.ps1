<#
.SYNOPSIS
    Endurecimento do Microsoft Defender Antivirus (Windows 10/11) via PowerShell / Action1.
.DESCRIPTION
    Ativa proteção em nuvem avançada, Network Protection (IPS de saída) e 10 regras ASR (Attack Surface Reduction).
#>

Write-Host "Iniciando configuracao de Hardening do Microsoft Defender..." -ForegroundColor Cyan

# 1. Pre-requisitos obrigatorios (Protecao em Tempo Real e Nuvem)
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -MAPSReporting Advanced
Set-MpPreference -SubmitSamplesConsent SendAllSamples

# 2. Ativa o Network Protection (Bloqueio de rede para todos os aplicativos)
Set-MpPreference -EnableNetworkProtection Enabled

# 3. Lista das principais regras ASR (GUIDs oficiais da Microsoft)
$RegrasASR = @(
    "56a863a9-875e-4185-98a7-b882c64b5ce5", # Bloqueia abuso de drivers vulneraveis assinados
    "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c", # Bloqueia Adobe Reader de criar processos filhos
    "d4f940ab-401b-4efc-aadc-ad5f3c50688a", # Bloqueia apps do Office de criar processos filhos
    "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2", # Bloqueia roubo de credenciais do processo LSASS
    "be9ba2d9-53ea-4cdc-84e5-9b1eeee46550", # Bloqueia conteudo executavel de e-mail e webmail
    "3b576869-a4ec-4529-8536-b80a7769e899", # Bloqueia apps do Office de criar conteudo executavel
    "75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84", # Bloqueia apps do Office de injetar codigo em outros processos
    "d3e037e1-3eb8-44c8-a917-57927947596d", # Bloqueia JavaScript ou VBScript de iniciar executaveis baixados
    "5beb7efe-fd9a-4556-801d-275e5ffc04cc", # Bloqueia execucao de scripts potencialmente ofuscados
    "c1db55ab-c21a-4637-bb3f-a12568109d35"  # Usa protecao avancada contra ransomware
)

foreach ($regra in $RegrasASR) {
    Add-MpPreference -AttackSurfaceReductionRules_Ids $regra -AttackSurfaceReductionRules_Actions Enabled
}

# 4. Validacao do Status
$netProt = (Get-MpPreference).EnableNetworkProtection
Write-Host "Status Network Protection (1 = Ativo): $netProt" -ForegroundColor Green
Write-Host "Hardening aplicado com sucesso!" -ForegroundColor Green
