# 🚩 Sistema de portões

Este recurso permite a criação e controle de portões semi automático em servidores MTA:SA, tanto no lado do cliente quanto no servidor.

## Requisitos

-   **MTA:SA 1.6**

## Instalação

1. **Baixe o repositório** e extraia os arquivos na pasta `resources` do seu servidor MTA:SA.
2. **Inicie o resource** no seu servidor:
    ```bash
    start mta_gates
    ```

## Configuração

O arquivo `shared/config.lua` contém todas as configurações principais do recurso, incluindo:

-   **gates**: Defina os portões, suas coordenadas e grupos de ACL que têm permissão para operar os portões.
-   **main.command**: Defina o comando para pré-visualizar os objetos no cliente.

### Exemplo de Configuração de um Portão

```lua
gates = {

    {
        id = 980, -- ID do objeto do portão
        delay = 1000, -- Tempo de delay para abrir/fechar
        group = "Console", -- Grupo de ACL que tem permissão para interagir com o portão
        key = { -- Posição da chave
            x = -693.597,
            y = 961.21,
            z = 12.813,
            r = 270
        },
        gate = {
            closed = { -- Posição do portão fechado
                x = -693.489,
                y = 966.079,
                z = 12.655,
                rx = 0,
                ry = 0,
                rz = 90
            },
            open = { -- Posição do portão aberto
                x = -693.489,
                y = 966.079,
                z = 8.555,
                rx = 0,
                ry = 0,
                rz = 90
            }
        }
    }

}
```

## Utilização

### Lado do Cliente

-   **Ativação**: O jogador com permissões pode visualizar e mover o portão.
-   **Teclas**:
    -   `Enter`: Copia a posição e rotação do objeto atual para a área de transferência.
    -   `Backspace`: Ativa/desativa o sistema de portões.
    -   `LCTRL`: Muda o modo de movimentação do objeto (horizontal/vertical).
    -   `LALT`: Ativa o modo de movimentação lenta.
    -   `Mouse Wheel Up/Down`: Rotaciona o objeto.

### Lado do Servidor

-   **Comando de Pré-visualização**: Para pré-visualizar um objeto, use:
    ```bash
    /preview <id_do_objeto>
    ```
-   **Interação com Portão**: Clicar no portão abrirá ou fechará, dependendo de seu estado atual.

## Funções

-   `Gate:open(object)`: Abre o menu de movimentação de objetos.
-   `Gate:close()`: Fecha o menu de movimentação e remove o objeto criado.
-   `Gate:toggle(object)`: Alterna entre abrir/fechar o menu de movimentação.
-   `Gate:create(object)`: Cria um objeto no mundo.
-   `Gate:preview(player, object)`: Permite um jogador visualizar um objeto no mundo.

## Eventos

-   **Cliente**:
    -   `gate:preview`: É chamado quando o jogador pré-visualiza um objeto.
-   **Servidor**:

    -   `onResourceStart`: Inicia o recurso e carrega as configurações dos portões.
    -   `onElementClicked`: Detecta quando um objeto de portão é clicado.

    ## Contribuição

Para contribuir, siga as diretrizes de contribuição e envie um pull request.

## Licença

Este projeto está licenciado sob a Licença MIT.

## Créditos

-   Desenvolvedor Principal: zFelpszada
