# 🎨 Flutter Image Filter

<img src="https://img.shields.io/badge/flutter-💙-blue" alt="Flutter Badge" />
<img src="https://img.shields.io/badge/platforms-iOS%20%7C%20Android-lightgrey" alt="Platforms Badge" />
<img src="https://img.shields.io/badge/filtro-cinza🖤-black" alt="Filtro Cinza" />

Um laboratório mobile para testar desempenho de filtros de imagem em escala de cinza — implementados em **Dart**, **C**, **Rust**, **Kotlin** e **Swift**.  
Totalmente construído em **Flutter** com foco em benchmarking entre linguagens nativas e multiplataforma.

---

## 🧪 O que esse app faz?

- Aplica um filtro **grayscale** (tons de cinza) em imagens tiradas pela camera.
- Permite comparar a performance de implementações em:
  - 🐦 Dart (puro)
  - 🦀 Rust (via FFI)
  - 🧬 C (via FFI)
  - 🤖 Kotlin/Native (Android)
  - 🍏 Swift (iOS)
- Exibe o **tempo de execução** de cada filtro, lado a lado.

---

## 🚀 Tecnologias usadas

| Camada           | Tecnologia     |
|------------------|----------------|
| UI/Frontend      | Flutter        |
| Filtro #1        | Dart           |
| Filtro #2        | C (via FFI)    |
| Filtro #3        | Rust (via FFI) |
| Filtro #4        | Kotlin Native  |
| Filtro #5        | Swift          |

---

## 💾 Armazenamento Local

Este projeto usa o [ObjectBox](https://pub.dev/packages/objectbox) como banco de dados local para armazenar os resultados dos filtros aplicados (tempo, linguagem usada, etc).

---

# Rust (via cargo-ndk ou cargo-lipo)

# C (pré-compilado via NDK)


## 🧙‍♂️ Autor

Desenvolvido por **Gabriel Amat** — Mobile Dev, tech lover e pai da Ana Luísa 💜
