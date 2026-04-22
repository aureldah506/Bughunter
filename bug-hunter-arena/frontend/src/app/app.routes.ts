import { Routes } from '@angular/router';
import { LandingPageComponent } from './components/landing-page/landing-page';
import { AuthComponent } from './components/auth/auth';
import { TeamDashboardComponent } from './components/team-dashboard/team-dashboard';
import { GameArenaComponent } from './components/game-arena/game-arena';

export const routes: Routes = [
  { path: '', component: LandingPageComponent }, // Page de présentation par défaut
  { path: 'login', component: AuthComponent },    // Page de connexion déplacée ici
  { path: 'team', component: TeamDashboardComponent },
  { path: 'arena', component: GameArenaComponent },
  { path: '**', redirectTo: '' } 
];