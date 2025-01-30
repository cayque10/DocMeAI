# DocMeAI

## Descrição
O **DocMeAI** é um facilitador que permite, de forma rápida e prática, documentar métodos dentro das suas units no Delphi utilizando **Inteligência Artificial**. A ferramenta gera automaticamente os **XML Documentation Comments** para seus métodos, simplificando a documentação de código e aumentando a produtividade.

---

## Instruções de Instalação

### **Pré-requisitos**
Para utilizar o **DocMeAI**, você precisará ter instalado o **DelphiOpenAI**. Siga as etapas abaixo para instalar e configurar o projeto:

1. **Baixar o DelphiOpenAI**
   - Acesse o repositório oficial do DelphiOpenAI: [https://github.com/HemulGM/DelphiOpenAI](https://github.com/HemulGM/DelphiOpenAI).
   - Baixe o repositório ou clone para sua máquina.

2. **Build e Instalação**
   - Abra o projeto do **DelphiOpenAI** no Delphi.
   - **Compile** e **instale** o pacote para que os componentes do DelphiOpenAI fiquem disponíveis na sua IDE.

3. **Configuração do DocMeAI**
   - Abra o DocMeAI no Delphi.
   - Builde e instale o pacote.

---

## Como Configurar

### **Configuração Inicial**
1. Acesse o menu **"Configurations"** no DocMeAI.
2. Informe os seguintes dados obrigatórios para configurar o acesso aos serviços de IA do ChatGPT:
   - **API Key**: Sua chave de API fornecida pela OpenAI.
   - **Modelo de IA**: O modelo utilizado, como `gpt-4o-mini`.
   - **Máximo de Tokens**: Limite de tokens para as respostas.
   - **Temperatura**: Controle da criatividade da IA (valor entre `0.0` e `1.0`).
   - ![image](https://github.com/user-attachments/assets/a670d1d9-769a-4c8d-b167-318e0449b512)


3. Clique em **Salvar** para concluir a configuração.

---

## Como Usar

1. **Selecione os métodos que deseja documentar** em sua unit.
2. Use o **atalho** `CTRL + SHIFT + D` ou clique no menu **"Documentation"**.
3. (Opcional) Insira instruções adicionais antes de gerar a documentação, caso queira orientar a IA para casos específicos.
4. Clique em **"Document"**.
5. O código selecionado será automaticamente documentado com os **XML Documentation Comments** do Delphi.

---

## Exemplo de Saída

Abaixo está um exemplo de método após ser documentado pelo DocMeAI:

### Antes:
```pascal
function CalculateTotal(const pValue1, pValue2: Double): Double;
begin
  Result := pValue1 + pValue2;
end;
```

### Depois:
```pascal
/// <summary>
/// Calculates the total sum of two values.
/// </summary>
/// <param name="pValue1">The first value to be summed.</param>
/// <param name="pValue2">The second value to be summed.</param>
/// <returns>The total sum of the two values.</returns>
function CalculateTotal(const pValue1, pValue2: Double): Double;
begin
  Result := pValue1 + pValue2;
end;
```
Demonstração:


https://github.com/user-attachments/assets/fee1905f-dfff-4fcb-a695-3f9aefc2495a



