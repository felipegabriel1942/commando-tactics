# Commando Tactics — Fase 1 (Vertical Slice)

# 1. Base do Projeto

## Estrutura inicial

* [x] Criar projeto no Godot
* [x] Definir resolução base
* [x] Configurar câmera
* [x] Criar cena principal
* [x] Criar estrutura de pastas
* [ ] Configurar Input Map

## Organização

* [x] Criar autoloads necessários
* [ ] Criar GameStateManager
* [x] Criar GridManager
* [ ] Criar TurnManager

---

# 2. Sistema de Grid

## Grid

* [x] Criar grid baseado em Vector2i
* [x] Converter grid ↔ posição mundial
* [ ] Destacar célula sob mouse
* [x] Sistema de ocupação de células
* [ ] Impedir unidades na mesma célula

## Pathfinding

* [ ] Implementar pathfinding
* [ ] Mostrar caminho visualmente
* [ ] Limitar movimentação por alcance/AP

---

# 3. Sistema de Turnos

## Fluxo de turnos

* [ ] Turno do jogador
* [ ] Turno dos inimigos
* [ ] Fim de turno
* [ ] Bloquear inputs fora do turno

## Fila de ações

* [ ] Garantir que animações terminem antes da próxima ação
* [ ] Esperar movimentação finalizar
* [ ] Esperar ataque finalizar

---

# 4. Sistema de Action Points (AP)

## AP

* [ ] Criar AP máximo
* [ ] Consumir AP ao mover
* [ ] Consumir AP ao atirar
* [ ] Restaurar AP no início do turno

## UI

* [ ] Mostrar AP atual
* [ ] Mostrar custo das ações

---

# 5. Jogador

## Movimento

* [ ] Selecionar destino
* [ ] Movimentar no grid
* [ ] Animação de movimentação

## Combate

* [ ] Selecionar alvo
* [ ] Atirar
* [ ] Aplicar dano
* [ ] Matar inimigo
* [ ] Animação simples de tiro

## Status

* [ ] Vida
* [ ] Munição
* [ ] Granadas (placeholder)

---

# 6. Inimigos

## IA básica

* [ ] Detectar jogador próximo
* [ ] Mover em direção ao jogador
* [ ] Procurar cover simples
* [ ] Atacar jogador

## Controle de turno

* [ ] Inimigos agem um por vez
* [ ] Esperar ação terminar antes do próximo inimigo

---

# 7. Sistema de Cover

## Cover

* [ ] Identificar células com cover
* [ ] Reduzir chance de dano
* [ ] Mostrar visualmente células protegidas

## Regras

* [ ] Cover parcial
* [ ] Cover total

---

# 8. Sistema de Combate

## Tiro

* [ ] Chance de acerto
* [ ] Aplicar dano
* [ ] Mostrar hit/miss

## Feedback

* [ ] Flash ao receber dano
* [ ] Efeito simples de impacto
* [ ] Texto flutuante de dano

---

# 9. Interface

## HUD

* [ ] Vida do jogador
* [ ] AP atual
* [ ] Munição atual
* [ ] Botão fim de turno

## Feedback visual

* [ ] Mostrar alcance de movimento
* [ ] Mostrar alcance de tiro
* [ ] Mostrar inimigo selecionado

---

# 10. Mapa de Teste

## Vertical Slice

* [ ] Criar mapa pequeno
* [ ] Adicionar obstáculos
* [ ] Adicionar covers
* [ ] Adicionar barris explosivos placeholder
* [ ] Adicionar 3–5 inimigos

---

# 11. Polimento Inicial

## Sensação de jogo

* [ ] Ajustar velocidade das animações
* [ ] Ajustar tempo dos turnos
* [ ] Ajustar custo de AP
* [ ] Ajustar precisão

## UX

* [ ] Garantir clareza visual
* [ ] Garantir leitura fácil do grid
* [ ] Garantir feedback imediato

---

# 12. Critério de “Fase 1 concluída”

A Fase 1 está pronta quando:

* [ ] O jogador consegue completar uma missão simples
* [ ] O combate é divertido repetidamente
* [ ] O loop básico funciona sem bugs críticos
* [ ] O jogador entende claramente o estado do combate
* [ ] Existe sensação de tensão tática
* [ ] Existe sensação de “herói de ação tático”

---

# Não implementar agora

Evitar:

* [ ] múltiplas armas
* [ ] stealth
* [ ] skill tree
* [ ] multiplayer
* [ ] procedural generation
* [ ] inventário complexo
* [ ] veículos
* [ ] destruição avançada
* [ ] mapas gigantes
* [ ] dezenas de inimigos
