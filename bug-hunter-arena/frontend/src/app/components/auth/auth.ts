import { Component, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common'; // Pour le *ngIf
import { FormsModule } from '@angular/forms'; // Pour le [(ngModel)]
import { Router } from '@angular/router';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-auth',
  standalone: true,
  imports: [CommonModule, FormsModule], // Ajoute ça ici
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './auth.html',
  styleUrls: ['./auth.css']
})
export class AuthComponent {
  // Mode par défaut
  isLoginMode = true;
  errorMessage = '';

  // Objet pour stocker les saisies du formulaire
  formData = {
    name: '',
    password: '',
    experts: {
      1: '', // PHP
      2: '', // React
      3: '', // C++
      4: '', // C#
      5: ''  // Mobile
    }
  };

  constructor(private apiService: ApiService, private router: Router) {}

  // Change entre Connexion et Inscription
  toggleMode() {
    this.isLoginMode = !this.isLoginMode;
    this.errorMessage = '';
  }

  onSubmit() {
    if (this.isLoginMode) {
      // LOGIQUE DE CONNEXION
      this.apiService.loginTeam({ name: this.formData.name, password: this.formData.password })
        .subscribe({
          next: (res) => {
            localStorage.setItem('team_id', res.team.id);
            localStorage.setItem('team_data', JSON.stringify(res.team));
            this.router.navigate(['/team']); // Direction le dashboard !
          },
          error: (err) => {
            this.errorMessage = "Identifiants incorrects.";
          }
        });
    } else {
      // LOGIQUE D'INSCRIPTION
      this.apiService.registerTeam(this.formData).subscribe({
        next: (res) => {
          alert("Escouade créée ! Connectez-vous maintenant.");
          this.isLoginMode = true;
        },
        error: (err) => {
          this.errorMessage = "Erreur lors de la création de l'escouade.";
        }
      });
    }
  }
}