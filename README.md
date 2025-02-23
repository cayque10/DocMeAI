# DocMeAI

## Descrição
O **DocMeAI** é um facilitador que permite, de forma rápida e prática, documentar métodos dentro das suas units no Delphi utilizando **Inteligência Artificial**. A ferramenta gera automaticamente os **XML Documentation Comments** para seus métodos, simplificando a documentação de código e aumentando a produtividade.

Agora, com o novo recurso **Diff Comment**, o DocMeAI também gera automaticamente um resumo das alterações realizadas em um projeto versionado com Git. Essa funcionalidade ajuda a entender rapidamente as mudanças feitas no código, facilitando revisões e commits mais claros.

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
   - ![image](https://github.com/user-attachments/assets/380fe3a3-82dc-4c32-9d6a-f15f70d70d68)
  
3. Para o **Diff Comment**, acesse a aba Git e efetue as configurações dos campos.
4. ![image](https://github.com/user-attachments/assets/235cb2fd-4827-428c-beaa-1277056e46e1)
5. Clique em **Salvar** para concluir a configuração.

---

## Como Usar

### **Documentação de Código**
1. **Selecione os métodos que deseja documentar** em sua unit.
2. Use o **atalho** `CTRL + SHIFT + D` ou clique no menu **"Documentation"**.
3. (Opcional) Insira instruções adicionais antes de gerar a documentação, caso queira orientar a IA para casos específicos.
4. Clique em **"Document"**.
5. ![Documentação](https://github.com/user-attachments/assets/edf3103b-ef58-4b5f-92f6-18e70edfc57d)
6. O código selecionado será automaticamente documentado com os **XML Documentation Comments** do Delphi.

### **Diff Comment**
1. **Utilize o recurso Diff Comment** para gerar um resumo automático das alterações realizadas em seu projeto versionado com Git.
2. O recurso analisa:
   - **Arquivos modificados**: Detecta automaticamente as mudanças em arquivos rastreados.
   - **Arquivos staged**: Inclui arquivos preparados para commit usando o comando `git add`.
   - **Novos arquivos**: Lembre-se de usar `git add` para que arquivos novos sejam incluídos no resumo.
3. Acesse o menu **"Diff Comment"** e clique em **"Generate Diff"** para criar o resumo.
4. O DocMeAI irá gerar um resumo das alterações agrupadas por arquivo, destacando as principais modificações funcionais e estruturais.
5. ![image](https://github.com/user-attachments/assets/4ae88476-b4bc-4b6e-aacd-3b4d911fe8b4)


**Nota:** Apenas arquivos modificados ou staged serão analisados. Para novos arquivos, certifique-se de adicioná-los com `git add`.

---

## Exemplo de Saída

### Documentação de Código

#### Antes:
```pascal
function CalculateTotal(const pValue1, pValue2: Double): Double;
begin
  Result := pValue1 + pValue2;
end;
