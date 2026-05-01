import { Component, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-auth',
  standalone: true,
  imports: [CommonModule, FormsModule],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './auth.html',
  styleUrls: ['./auth.css']
})
export class AuthComponent {
  isLoginMode = true;
  errorMessage = '';
  
  formData = {
    name: '',
    password: '',
    experts: {} as any // Pour l'inscription
  };

  constructor(private apiService: ApiService, private router: Router) {}

  toggleMode() {
    this.isLoginMode = !this.isLoginMode;
    this.errorMessage = '';
  }

  onSubmit() {
    if (this.isLoginMode) {
      // --- LOGIQUE DE CONNEXION ---
      this.apiService.login({ name: this.formData.name, password: this.formData.password })
        .subscribe({
          next: (res) => {
            // Sauvegarde des infos de l'équipe pour le dashboard
            localStorage.setItem('team_id', res.team.id);
            localStorage.setItem('team_data', JSON.stringify(res.team));
            this.router.navigate(['/team']); 
          },
          error: (err) => {
            this.errorMessage = "Nom d'escouade ou code d'accès invalide.";
          }
        });
    } else {
      // --- LOGIQUE D'INSCRIPTION ---
      this.apiService.register(this.formData)
        .subscribe({
          next: (res) => {
            alert(res.message);
            this.toggleMode(); // Bascule vers connexion après succès
          },
          error: (err) => {
            this.errorMessage = err.error?.error || "Erreur lors de la création de l'escouade.";
          }
        });
    }
  }
}
