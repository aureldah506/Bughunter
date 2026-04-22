import { Component, OnInit, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api'; // Import vers ton service api.ts

@Component({
  selector: 'app-game-arena',
  standalone: true,
  imports: [CommonModule],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './game-arena.html',
  styleUrls: ['./game-arena.css']
})
export class GameArenaComponent implements OnInit {
  // Données du quiz et de l'équipe
  quiz: any = null;
  techName: string = '';
  expertName: string = '';
  teamId: number = 0;
  teamName: string = '';
  currentScore: number = 0;

  // États de l'interface
  isSubmitting = false;
  feedbackMessage: string | null = null;
  isCorrect: boolean = false;

  constructor(private apiService: ApiService, private router: Router) {}

  ngOnInit() {
    // 1. Récupération des données stockées dans le navigateur
    const savedQuiz = localStorage.getItem('current_quiz');
    const savedTech = localStorage.getItem('current_tech_name');
    const teamDataStr = localStorage.getItem('team_data');

    // Sécurité : Si une donnée manque, on renvoie au Dashboard
    if (!savedQuiz || !savedTech || !teamDataStr) {
      this.router.navigate(['/team']);
      return;
    }

    // 2. Initialisation des variables d'affichage
    this.quiz = JSON.parse(savedQuiz);
    this.techName = savedTech;
    
    const teamData = JSON.parse(teamDataStr);
    this.teamId = teamData.id;
    this.teamName = teamData.name;
    this.currentScore = teamData.score;

    // 3. Gestion de l'expert (Facultatif)
    // Mapping des noms de technos vers les clés de l'objet experts
    const techMap: { [key: string]: string } = {
      'PHP': '1', 
      'ReactJS': '2', 
      'C++': '3', 
      'C#': '4', 
      'Mobile': '5'
    };
    
    const techKey = techMap[this.techName];
    const assignedExpert = teamData.experts[techKey];

    // Si l'expert est vide ou non renseigné, on affiche un nom de code classe
    this.expertName = assignedExpert && assignedExpert.trim() !== '' 
                      ? assignedExpert 
                      : 'Agent de Liaison';
  }

  /**
   * Envoie la réponse choisie au backend pour validation
   */
  submitAnswer(answerId: number) {
    if (this.isSubmitting) return;
    
    this.isSubmitting = true;
    
    this.apiService.validateAnswer(this.teamId, answerId).subscribe({
      next: (res) => {
        this.isCorrect = res.correct;
        this.feedbackMessage = res.correct 
          ? "Anomalie corrigée ! Protocole de restauration complété." 
          : "Échec du patch. L'anomalie se propage.";

        // Mise à jour du score local si la réponse est juste
        if (res.correct) {
          const teamData = JSON.parse(localStorage.getItem('team_data')!);
          teamData.score += 10;
          localStorage.setItem('team_data', JSON.stringify(teamData));
        }

        // Retour au Dashboard après 2.5 secondes pour laisser lire le message
        setTimeout(() => {
          localStorage.removeItem('current_quiz');
          localStorage.removeItem('current_tech_name');
          this.router.navigate(['/team']);
        }, 2500);
      },
      error: (err) => {
        this.feedbackMessage = "Erreur de liaison avec le noyau central.";
        this.isCorrect = false;
        setTimeout(() => this.router.navigate(['/team']), 2500);
      }
    });
  }
}