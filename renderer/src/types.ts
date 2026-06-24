export interface Scene {
  sceneNumber: number;
  duration: number;
  narration: string;
  visualDescription: string;
  visualType: 'title' | 'content' | 'example' | 'formula' | 'summary';
  subject: string;
}

export interface VideoScript {
  title: string;
  subject: string;
  class: string;
  language: string;
  totalDuration: number;
  scenes: Scene[];
}
