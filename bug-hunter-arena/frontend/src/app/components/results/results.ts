import { Component, OnInit, CUSTOM_ELEMENTS_SCHEMA, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api';

const AVATAR_EMOJIS: Record<string, string> = {
  robot:  '🤖', ninja:  '🥷', alien:  '👾',
  hacker: '💻', wizard: '🧙', cyborg: '🦾'
};

@Component({
  selector: 'app-results',
  standalone: true,
  imports: [CommonModule],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './results.html',
  styleUrls: ['./results.css']
})
export class ResultsComponent implements OnInit {
  leaderboard       = signal<any[]>([]);
  loading           = signal(true);
  sessionScore      = signal(0);
  questionsAnswered = signal(0);
  correctAnswers    = signal(0);
  teamName          = signal('');
  myHistory         = signal<any[]>([]);
  activeExpert: any = null;

  constructor(private apiService: ApiService, private router: Router) {}

  ngOnInit(): void {
    const teamData = localStorage.getItem('team_data');
    if (teamData) this.teamName.set(JSON.parse(teamData).name ?? '');

    const stats = localStorage.getItem('session_stats');
    if (stats) {
      const s = JSON.parse(stats);
      this.sessionScore.set(s.sessionScore ?? 0);
      this.questionsAnswered.set(s.questionsAnswered ?? 0);
      this.correctAnswers.set(s.correctAnswers ?? 0);
    }

    // Récupérer l'expert actif de la session
    const ae = localStorage.getItem('active_expert');
    if (ae) this.activeExpert = JSON.parse(ae);

    this.apiService.getLeaderboard().subscribe({
      next: (data) => {
        this.leaderboard.set(data);
        // Extraire l'historique de l'équipe connectée
        const myTeam = data.find((t: any) => t.name === this.teamName());
        if (myTeam?.history) this.myHistory.set(myTeam.history);
        this.loading.set(false);
      },
      error: () => { this.loading.set(false); }
    });
  }

  getAvatarEmoji(avatar: string): string {
    return AVATAR_EMOJIS[avatar] ?? '🤖';
  }

  playAgain(): void {
    localStorage.removeItem('session_stats');
    localStorage.removeItem('current_quiz');
    localStorage.removeItem('active_expert');
    this.router.navigate(['/team']);
  }

  logout(): void {
    this.apiService.logout().subscribe({ error: () => {} });
    localStorage.clear();
    this.router.navigate(['/']);
  }
}
