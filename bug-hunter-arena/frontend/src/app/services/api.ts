import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, interval, switchMap } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private baseUrl = 'http://localhost/Bughunter/bug-hunter-arena/backend/public/api';

  constructor(private http: HttpClient) {}

  register(data: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/register`, data);
  }

  login(data: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/login`, data);
  }

  logout(): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/logout`, {});
  }

  getRandomQuiz(techId?: number, seenIds?: number[]): Observable<any> {
    let url = techId
      ? `${this.baseUrl}/quiz/random?tech=${techId}`
      : `${this.baseUrl}/quiz/random`;
    if (seenIds && seenIds.length > 0) {
      url += (url.includes('?') ? '&' : '?') + `seen=${seenIds.join(',')}`;
    }
    return this.http.get(url);
  }

  validateAnswer(quizId: number, answerId: number, teamId: number, playerName?: string, expertId?: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/quiz/validate`, {
      quiz_id:     quizId,
      answer_id:   answerId,
      team_id:     teamId,
      player_name: playerName ?? '',
      expert_id:   expertId ?? null
    });
  }

  getLeaderboard(): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/leaderboard`);
  }

  getSpectatorData(): Observable<any> {
    return this.http.get(`${this.baseUrl}/spectator`);
  }

  pollSpectator(): Observable<any> {
    return interval(3000).pipe(switchMap(() => this.getSpectatorData()));
  }

  getExperts(teamId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.baseUrl}/experts?team_id=${teamId}`);
  }

  updateAvatar(expertId: number, avatar: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/experts/avatar`, { expert_id: expertId, avatar });
  }

  buyHint(expertId: number, quizId: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/experts/hint`, { expert_id: expertId, quiz_id: quizId });
  }

  resetScores(adminKey: string): Observable<any> {
    return this.http.post(`${this.baseUrl}/admin/reset`, { admin_key: adminKey });
  }

  getAdminStats(): Observable<any> {
    return this.http.get(`${this.baseUrl}/admin/stats`);
  }
}
