# Bug Hunter Arena

Jeu compétitif de debugging en équipe — TPRE300 · EPSI 2024-2025

## Stack

| Couche | Techno |
|---|---|
| Frontend | Angular 21 (standalone, signals) |
| Backend | PHP 8 (MVC, PDO) |
| Base de données | MySQL |
| Styles | Tailwind CSS |

---

## Structure

```
bug-hunter-arena/
├── frontend/                          ← Angular
│   └── src/app/
│       ├── guards/
│       │   └── auth.guard.ts          ← Protection des routes
│       ├── services/
│       │   ├── api.service.ts         ← Appels HTTP vers le backend
│       │   └── sound.service.ts       ← Sons (bonne/mauvaise réponse, chrono)
│       └── components/
│           ├── landing-page/          ← Page d'accueil
│           ├── auth/                  ← Connexion / Inscription
│           ├── team-dashboard/        ← Interface équipe (score, experts, classement live)
│           ├── select-expert/         ← Choix expert + avatar avant de jouer
│           ├── game-arena/            ← Quiz (chrono, indices, économie virtuelle)
│           ├── spectator/             ← Vue spectateur temps réel
│           ├── results/               ← Récapitulatif session + corrections
│           └── admin/                 ← Panel admin (stats + reset scores)
│
└── backend/                           ← PHP MVC
    ├── src/
    │   ├── Controllers/
    │   │   ├── AuthController.php     ← Login / Register
    │   │   ├── QuizController.php     ← Quiz aléatoire + validation
    │   │   ├── ExpertController.php   ← Experts, avatars, indices
    │   │   ├── LeaderboardController.php
    │   │   ├── SpectatorController.php
    │   │   └── AdminController.php    ← Reset scores, stats globales
    │   └── Core/
    │       └── Router.php             ← Routeur API
    ├── config/
    │   └── Database.php               ← Connexion PDO MySQL (ignoré par git)
    └── public/
        └── index.php                  ← Point d'entrée
```

---

## Fonctionnalités

### Jeu
- Inscription des équipes avec 5 experts (PHP, ReactJS, C++, C#, Mobile)
- Sélection de l'expert qui joue + choix d'avatar avant chaque session
- Quiz filtrés par domaine de l'expert (un expert PHP ne voit que des bugs PHP)
- 10 questions par session, 30s par question avec chrono
- Anti-doublons — les quiz déjà vus ne réapparaissent pas dans la session
- Validation automatique avec feedback visuel et sonore

### Économie virtuelle
- Chaque bonne réponse = **+10 coins**
- Acheter un indice = **-5 coins** (révèle la bonne réponse)
- Les coins s'accumulent entre les sessions par expert

### Interfaces
| Route | Description |
|---|---|
| `/` | Landing page |
| `/login` | Connexion / Inscription |
| `/team` | Interface équipe — score, experts, classement live, historique |
| `/select-expert` | Choix de l'expert et de l'avatar |
| `/arena` | Interface joueur actif — quiz, chrono, indice |
| `/spectator` | Vue spectateur live (accessible sans connexion) |
| `/results` | Récapitulatif session avec corrections des ratés |
| `/admin` | Panel admin (clé : `bughunter2025`) |

### Vue spectateur
- Équipe active avec tous ses experts (techno, score, coins)
- Classement temps réel mis à jour toutes les 3s
- Historique des corrections avec bouton "Voir la correction" sur les ratés

---

## Installation

### Base de données
```bash
# Importer le schéma complet
mysql -u root -p < bug-hunter-arena/sql/init.sql

# Si la BDD existe déjà, appliquer les migrations
mysql -u root -p bug_hunter_arena < bug-hunter-arena/backend/sql/update_v2.sql
mysql -u root -p bug_hunter_arena < bug-hunter-arena/backend/sql/update_v3.sql
```

### Backend
Placer `bug-hunter-arena/` dans `www/` (WAMP) ou `htdocs/` (XAMPP).

Copier et configurer `database.php` :
```bash
cp bug-hunter-arena/backend/config/database.example.php bug-hunter-arena/backend/config/database.php
```
```php
$host = 'localhost';
$db   = 'bug_hunter_arena';
$user = 'root';
$pass = ''; // vide par défaut sur WAMP
```

API accessible sur : `http://localhost/Bughunter/bug-hunter-arena/backend/public/api/`

### Frontend
```bash
cd bug-hunter-arena/frontend
npm install
ng serve
```
Accessible sur `http://localhost:4200`

---

## API Endpoints

| Méthode | Route | Description |
|---|---|---|
| POST | `/api/auth/register` | Créer une équipe |
| POST | `/api/auth/login` | Connexion |
| GET | `/api/quiz/random?tech={id}&seen={ids}` | Quiz aléatoire (anti-doublons) |
| POST | `/api/quiz/validate` | Valider une réponse |
| GET | `/api/experts?team_id={id}` | Experts d'une équipe |
| POST | `/api/experts/avatar` | Mettre à jour l'avatar |
| POST | `/api/experts/hint` | Acheter un indice (5 coins) |
| GET | `/api/leaderboard` | Classement avec experts |
| GET | `/api/spectator` | Données vue spectateur |
| GET | `/api/admin/stats` | Statistiques globales |
| POST | `/api/admin/reset` | Réinitialiser les scores |

---

## Schéma BDD

```
teams          — équipes (nom, score)
experts        — experts par équipe (techno, avatar, coins, score)
technologies   — PHP / ReactJS / C++ / C# / Mobile
quizzes        — bugs à corriger (description + code)
answers        — réponses QCM (4 par quiz)
bug_history    — historique des corrections (avec question + correction)
hints_used     — indices achetés
game_session   — session en cours (vue spectateur)
```

---

## Branches Git

```
main          ← stable
├── backend   ← développement PHP
└── frontend  ← développement Angular
```
