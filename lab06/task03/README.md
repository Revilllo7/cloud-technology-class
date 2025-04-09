# Trójwarstwowa Aplikacja w Docker

## Skład aplikacji

- **Frontend:**
- **Backend:**
- **Database:**

## Sieci

- `frontend_network`: frontend + backend
- `backend_network`: backend + database (tylko backend ma dostęp)

## Uruchomienie

```bash
docker-compose up --build
```

## Testowanie

run `./check.sh` or open `localhost:3000`
