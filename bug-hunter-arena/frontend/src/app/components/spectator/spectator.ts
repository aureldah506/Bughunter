import { Component, OnInit, OnDestroy, CUSTOM_ELEMENTS_SCHEMA, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api';
import { Subscription } from 'rxjs';

const AVATAR_EMOJIS: Record<string, string> = {
  robot: '🤖', ninja: '🥷', alien: '👾',
  hacker: '💻', wizard: '🧙', cyborg: '🦾'
};

@Component({
  selector: 'app-spectator',
  standalone: true,
  imports: [CommonModule],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './spectator.html',
  styleUrls: ['./spectator.css']
})
export class SpectatorComponent implements OnInit, OnDestroy {
  teams         = signal<any[]>([]);
  activePlayer  = signal<string>('—');
  activeExperts = signal<any[]>([]);
  history       = signal<any[]>([]);
  loading       = signal(true);
  isLoggedIn    = false;

  private sub: Subscription | null = null;

  constructor(private apiService: ApiService, private router: Router) {}

  ngOnInit(): void {
    this.isLoggedIn = !!localStorage.getItem('team_data');
    this.apiService.getSpectatorData().subscribe({
      next: (data) => { this.applyData(data); this.loading.set(false); },
      error: () => this.loading.set(false)
    });
    this.sub = this.apiService.pollSpectator().subscribe({
      next: (data) => this.applyData(data)
    });
  }

  ngOnDestroy(): void { this.sub?.unsubscribe(); }

  private applyData(data: any): void {
    this.teams.set(data.teams ?? []);
    this.activePlayer.set(data.active_player ?? '—');
    this.activeExperts.set(data.active_experts ?? []);
    this.history.set(data.history ?? []);
  }

  getAvatarEmoji(avatar: string): string {
    return AVATAR_EMOJIS[avatar] ?? '🤖';
  }

  goHome(): void { this.router.navigate(['/']); }
  goTeam(): void { this.router.navigate(['/team']); }
}
