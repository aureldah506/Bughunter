import { Routes } from '@angular/router';
import { LandingPageComponent }   from './components/landing-page/landing-page';
import { AuthComponent }          from './components/auth/auth';
import { TeamDashboardComponent } from './components/team-dashboard/team-dashboard';
import { SelectExpertComponent }  from './components/select-expert/select-expert';
import { GameArenaComponent }     from './components/game-arena/game-arena';
import { ResultsComponent }       from './components/results/results';
import { SpectatorComponent }     from './components/spectator/spectator';
import { AdminComponent }         from './components/admin/admin';
import { authGuard, expertGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '',              component: LandingPageComponent },
  { path: 'login',         component: AuthComponent },
  { path: 'spectator',     component: SpectatorComponent },
  { path: 'admin',         component: AdminComponent },

  // Routes protégées — nécessitent d'être connecté
  { path: 'team',          component: TeamDashboardComponent,  canActivate: [authGuard] },
  { path: 'select-expert', component: SelectExpertComponent,   canActivate: [authGuard] },
  { path: 'results',       component: ResultsComponent,        canActivate: [authGuard] },

  // Route protégée — nécessite expert actif sélectionné
  { path: 'arena',         component: GameArenaComponent,      canActivate: [expertGuard] },

  { path: '**', redirectTo: '' }
];
