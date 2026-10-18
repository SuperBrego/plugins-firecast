param(
    [string]$SheetPath = (Join-Path $PSScriptRoot '..\fate_core.lfm')
)

$source = [System.IO.File]::ReadAllText(
    (Resolve-Path $SheetPath),
    [System.Text.UTF8Encoding]::new($false, $true)
)
$errors = [System.Collections.Generic.List[string]]::new()

function Assert-LayoutRule {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { $errors.Add($Message) }
}

# A ordem das linhas é a própria ordem do XML. Linhas ocultas por `visible`
# são reinseridas no topo pelo cliente Firecast e não devem voltar a ser usadas.
$previousPosition = -1
for ($i = 1; $i -le 16; $i++) {
    $tag = [regex]::Match($source, "<layout[^>]*name=`"rowPericia_$i`"[^>]*>")
    Assert-LayoutRule $tag.Success "Perícia $i não possui layout estável."
    Assert-LayoutRule ($tag.Value -notmatch 'visible=') "Perícia $i não pode usar visible."
    $position = $source.IndexOf("name=`"rowPericia_$i`"")
    Assert-LayoutRule ($position -gt $previousPosition) "Perícia $i está fora da ordem do XML."
    $previousPosition = $position
    $numero = '{0:D2}' -f $i
    $padraoNumero = "name=`"rowPericia_$i`"[^>]*><layout[^>]*><label text=`"$numero`""
    Assert-LayoutRule ($source -match $padraoNumero) "Perícia $i não possui numeração fixa $numero."
}

$previousPosition = -1
for ($i = 1; $i -le 10; $i++) {
    $tag = [regex]::Match($source, "<layout[^>]*name=`"rowFacanha_$i`"[^>]*>")
    Assert-LayoutRule $tag.Success "Façanha $i não possui layout estável."
    Assert-LayoutRule ($tag.Value -notmatch 'visible=') "Façanha $i não pode usar visible."
    $position = $source.IndexOf("name=`"rowFacanha_$i`"")
    Assert-LayoutRule ($position -gt $previousPosition) "Façanha $i está fora da ordem do XML."
    $previousPosition = $position
}

Assert-LayoutRule ($source -match 'row\.height = sheet\["pericia" \.\. i \.\. "_ativa"\] == true and 52 or 0') 'Perícias devem abrir/fechar por altura.'
Assert-LayoutRule ($source -match 'row\.height = sheet\["facanha" \.\. i \.\. "_ativa"\] == true and 32 or 0') 'Façanhas devem abrir/fechar por altura.'
Assert-LayoutRule ($source -match 'sheet\["pericia" \.\. \(ultimaPericia \+ 1\) \.\. "_ativa"\] = true') 'Adicionar Perícia deve usar o próximo índice final.'
Assert-LayoutRule ($source -match 'sheet\["facanha" \.\. \(ultimaFacanha \+ 1\) \.\. "_ativa"\] = true') 'Adicionar Façanha deve usar o próximo índice final.'

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'OK: ordem estável, numeração e inserção no fim confirmadas.'
