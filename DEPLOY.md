# Deploy — decidir.plataformaativa.com.br

Landing page estática (nginx) do Método DECIDIR, atrás do Traefik já existente no servidor.

## Padrão do servidor (producao / 147.93.15.198)

- Traefik v3.3, config dinâmica em `/opt/pilates/traefik/dynamic/`.
- Rede compartilhada: `traefik-public`.
- Entrypoint `websecure` (:443, com redirect de :80), certResolver `letsencrypt`.

## Primeiro deploy

```bash
# no servidor
cd /opt
git clone https://github.com/dariorego/decidir.git
cd decidir
docker compose up -d --build
# registrar rota no Traefik (file provider, watch automatico)
cp traefik/decidir.yml /opt/pilates/traefik/dynamic/decidir.yml
```

## Atualizar (nova versão)

```bash
cd /opt/decidir
git pull
docker compose up -d --build
# se o traefik/decidir.yml tiver mudado:
cp traefik/decidir.yml /opt/pilates/traefik/dynamic/decidir.yml
```

## Reverter (rollback)

```bash
# derrubar o container e remover a rota (não afeta os demais serviços)
cd /opt/decidir
docker compose down
rm -f /opt/pilates/traefik/dynamic/decidir.yml

# voltar para um commit anterior (se necessario):
cd /opt/decidir && git log --oneline -5
git checkout <hash-anterior>
docker compose up -d --build
```

## Observações

- Container isolado (`container_name: decidir`), sem publicar portas, apenas na rede `traefik-public`.
- Não altera Traefik global nem outros apps: só adiciona `dynamic/decidir.yml`.
- O certificado TLS é emitido automaticamente pelo Traefik no primeiro acesso (letsencrypt).
