[README_Reencontro_MZ.md](https://github.com/user-attachments/files/29658169/README_Reencontro_MZ.md)
## **`🇲🇿`** = **Reencontro MZ** 

## **Hackathon de Moçambique (Cursor) — Categoria 3: SOS / Reunião (Resposta)** 

_"Uma mãe perde o contacto com os filhos durante a enchente. Com a nossa aplicação, ela regista-os como desaparecidos. Um voluntário num abrigo a 5km encontra as crianças e faz o match. A família reúne-se."_ 

## Cy 

## Cy **O Problema e a Solução** 

Durante cheias e calamidades naturais em Moçambique, a quebra de infraestruturas de comunicação e a evacuação caótica resultam frequentemente na separação trágica de famílias. Enquanto a maioria das soluções  foca-se  na  prevenção  (Alertas)  ou  na  evacuação  (Rotas  Seguras),  o **Reencontro  MZ** atua diretamente na fase crítica de **Resposta (Categoria 3)** , providenciando uma plataforma de ponta a ponta otimizada para ligações lentas que liga quem procura a quem encontrou. 
## W 

##  **Funcionalidades Principais (Ponta a Ponta)** 

- **Registo de Pessoas Desaparecidas:** Formulário ultra-leve para familiares submeterem dados essenciais (nome, idade, foto opcional e último local conhecido). 

- **Registo de Pessoas Encontradas:** Interface dedicada para voluntários e gestores de centros de acolhimento/abrigos registarem cidadãos resgatados. 

- **Algoritmo de Matching Inteligente:** Cruzamento automático em tempo real baseado em fonética de nomes, idade aproximada e raio de localização geográfica para sugerir reencontros. 

- **Mapa de Abrigos Resiliente:** Visualização simplificada da localização dos abrigos e lista de pessoas acolhidas em cada ponto. 

- **Feed de SOS Urgente:** Canal direto de baixa largura de banda para pedidos críticos (água potável, medicamentos, bens de primeira necessidade). 

## **`🛠️` Stack Técnica e Arquitetura** 

Desenhado rigorosamente segundo os requisitos obrigatórios do desafio (Mobile-first, utilizável em 3G lento e com capacidade offline): 

|**Componente**|**Tecnologia**|**Motivação Estratégica**|
|---|---|---|
|**Frontend**|PWA (HTML5, CSS3,<br>Vanilla JS)|Carregamento instantâneo, consumo mínimo de dados,<br>sem dependências pesadas.|
|**Backend &**<br>**DB**|Supabase / Firebase|Base de dados em tempo real para atualizações imediatas<br>de_matches_e SOS.|



Reencontro MZ — README.md 

1 

|**Componente**|**Tecnologia**|**Motivação Estratégica**|
|---|---|---|
|**Offline**<br>**Support**|Service Workers &<br>LocalStorage|Permite registar dados mesmo sem rede; os dados são<br>sincronizados assim que detetar sinal 3G.|
|**Alojamento**|Vercel / Netlify|Distribuição global via CDN para garantir a menor latência<br>possível em Moçambique.|



## **Fluxo de Trabalho no Cursor (Requisito de Avaliação)** 

Esta solução foi inteiramente desenhada e desenvolvida utilizando o ecossistema do **Cursor** , maximizando a produtividade ao longo do hackathon: 

- **Composer & Agentes:** Utilizados para estruturar a arquitetura base do Service Worker e a lógica de sincronização em segundo plano. 

- **Chat & Regras:** Criação de regras personalizadas para garantir que todo o código gerado respeitasse a política de "dados mínimos" e boas práticas de acessibilidade mobile-first. 

## **Instalação e Execução Local** 

Siga os passos abaixo para rodar o projeto localmente: 

`# Clone o repositório git clone https://github.com/[seu-utilizador]/reencontro-mz.git` 

`# Aceda ao diretório do projeto cd reencontro-mz` 

`# Instale as dependências (se aplicável, ex: se usar Vite/Node) npm install` 

`# Inicie o servidor de desenvolvimento npm run dev` 


 

4. **2:30 - 3:00 (Conclusão):** Fecho com métricas de performance do PWA offline e impacto humano da solução. 

Reencontro MZ — README.md 

2 

