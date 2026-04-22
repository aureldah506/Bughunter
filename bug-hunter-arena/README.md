# Bug Hunter Arena 🚀

**Bug Hunter Arena** est une plateforme de compétition collaborative pour les bug hunters. L'application utilise une architecture full-stack moderne avec un backend PHP et un frontend Angular.

## 🏗️ Architecture Globale

### Backend (PHP - MVC)
Le serveur utilise un point d'entrée unique (`index.php`) qui redirige les requêtes via un routeur vers les contrôleurs appropriés.

```
backend/
├── config/                    # Configuration et connexion BDD (Singleton PDO)
│   └── Database.php
├── src/
│   ├── Core/
│   │   └── Router.php        # Routeur principal
│   ├── Controllers/          # Logique de traitement des requêtes
│   │   ├── AuthController.php
│   │   └── QuizController.php
│   └── Models/               # Interaction avec la BDD
│       ├── Team.php
│       └── Question.php
└── public/
    └── index.php             # Point d'entrée public
```

### Frontend (Angular + TypeScript)
Application single-page moderne utilisant Angular avec une architecture composant-basée et un styling Tailwind CSS.

```
frontend/
├── src/
│   ├── index.html            # Point d'entrée HTML
│   ├── main.ts               # Bootstrap Angular
│   ├── styles.css            # Styles globaux
│   └── app/
│       ├── app.ts            # Composant racine
│       ├── app.routes.ts     # Configuration du routing
│       ├── app.config.ts     # Configuration Angular
│       ├── app.css           # Styles du composant app
│       └── components/       # Composants réutilisables
│           ├── auth/         # Authentification
│           ├── game-arena/   # Arena de compétition
│           ├── landing-page/ # Page d'accueil
│           └── team-dashboard/ # Tableau de bord équipe
└── ...config files           # Angular, TypeScript, Tailwind configuration
```

### Base de Données (MySQL)

```
sql/
├── init.sql                  # Schéma et structure
└── fixtures.sql              # Données de test
```