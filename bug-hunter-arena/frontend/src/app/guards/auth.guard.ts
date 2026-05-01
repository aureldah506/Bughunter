import { inject } from '@angular/core';
import { Router, CanActivateFn } from '@angular/router';

// Guard : redirige vers /login si pas connecté
export const authGuard: CanActivateFn = () => {
  const router = inject(Router);
  if (localStorage.getItem('team_data')) return true;
  router.navigate(['/login']);
  return false;
};

// Guard : redirige vers /select-expert si pas d'expert actif
export const expertGuard: CanActivateFn = () => {
  const router = inject(Router);
  if (!localStorage.getItem('team_data')) {
    router.navigate(['/login']);
    return false;
  }
  if (!localStorage.getItem('active_expert')) {
    router.navigate(['/select-expert']);
    return false;
  }
  return true;
};
