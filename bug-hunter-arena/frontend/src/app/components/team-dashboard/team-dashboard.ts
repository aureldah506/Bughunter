import { Component, OnInit, OnDestroy, CUSTOM_ELEMENTS_SCHEMA, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { ApiService } from '../../services/api';
import { Subscription } from 'rxjs';

const AVATAR_EMOJIS: Record<string, string> = {
  robot: '🤖', ninja: '🥷', alien: '👾',
  hacker: '💻', wizard: '🧙', cyborg: '🦾'
};

@Component({
  selector: 'app-team-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './team-dashboard.html',
  styleUrls: ['./team-dashboard.css']
})
export class TeamDashboardComponent implements OnInit, OnDestroy {
  team: any = null;
  isLoading = false;

  leaderboard = signal<any[]>([]);
  history     = signal<any[]>([]);
  experts     = signal<any[]>([]); // experts complets avec coins/score

  readonly techColors: { [key: number]: string } = {
    1: 'text-cyan-400', 2: 'text-blue-400', 3: 'text-purple-400',
    4: 'text-emerald-400', 5: 'text-orange-400'
  };

  private sub: Subscription | null = null;

  constructor(private apiService: ApiService, private router: Router) {}

  ngOnInit(): void {
    const savedData = localStorage.getItem('team_data');
    if (!savedData) { this.router.navigate(['/']); return; }

    this.team = JSON.parse(savedData);
    this.isLoading = false;

    this.loadAll();

    // Polling toutes les 5s
    this.sub = this.apiService.pollSpectator().subscribe({
      next: (data) => {
        this.leaderboard.set(data.teams ?? []);
        this.history.set((data.history ?? []).slice(0, 5));
        const myTeam = (data.teams ?? []).find((t: any) => t.id == this.team?.id);
        if (myTeam) {
          this.team.score = myTeam.score;
          localStorage.setItem('team_data', JSON.stringify(this.team));
          // Mettre à jour les experts depuis le leaderboard
          if (myTeam.experts) this.experts.set(myTeam.experts);
        }
      }
    });
  }

  ngOnDestroy(): void { this.sub?.unsubscribe(); }

  private loadAll(): void {
    const teamId = parseInt(localStorage.getItem('team_id') ?? '0', 10);

    // Charger spectator (classement + historique)
    this.apiService.getSpectatorData().subscribe({
      next: (data) => {
        this.leaderboard.set(data.teams ?? []);
        this.history.set((data.history ?? []).slice(0, 5));
        const myTeam = (data.teams ?? []).find((t: any) => t.id == this.team?.id);
        if (myTeam?.experts) this.experts.set(myTeam.experts);
      }
    });

    // Charger experts complets si pas dans le leaderboard
    if (teamId) {
      this.apiService.getExperts(teamId).subscribe({
        next: (data) => { if (data.length) this.experts.set(data); }
      });
    }
  }

  spinWheel(): void {
    if (this.isLoading) return;
    // Ne plus charger le quiz ici — on le fera après avoir sélectionné l'expert
    // pour charger un quiz de SA technologie
    localStorage.removeItem('session_stats');
    localStorage.removeItem('active_expert');
    localStorage.removeItem('current_quiz');
    this.router.navigate(['/select-expert']);
  }

  getAvatarEmoji(avatar: string): string {
    return AVATAR_EMOJIS[avatar] ?? '🤖';
  }

  techColorByName(name: string): string {
    const map: Record<string, string> = {
      'PHP': 'text-cyan-400', 'ReactJS': 'text-blue-400',
      'C++': 'text-purple-400', 'C#': 'text-emerald-400', 'Mobile': 'text-orange-400'
    };
    return map[name] ?? 'text-slate-400';
  }

  logout(): void {
    this.apiService.logout().subscribe({ error: () => {} });
    localStorage.clear();
    this.router.navigate(['/']);
  }
}
