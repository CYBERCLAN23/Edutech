export const colors = {
  maths: { primary: '#1E3A5F', secondary: '#2D5F8A', accent: '#4A90D9', bg: '#E8F0FE', text: '#FFFFFF' },
  sciences: { primary: '#1B5E20', secondary: '#2E7D32', accent: '#66BB6A', bg: '#E8F5E9', text: '#FFFFFF' },
  francais: { primary: '#4A148C', secondary: '#6A1B9A', accent: '#AB47BC', bg: '#F3E5F5', text: '#FFFFFF' },
  histoire: { primary: '#BF360C', secondary: '#D84315', accent: '#FF7043', bg: '#FBE9E7', text: '#FFFFFF' },
  anglais: { primary: '#004D40', secondary: '#00695C', accent: '#26A69A', bg: '#E0F2F1', text: '#FFFFFF' },
  default: { primary: '#0D1B2A', secondary: '#1B2838', accent: '#4F46E5', bg: '#F1F5F9', text: '#FFFFFF' },
};

export function getSubjectColor(subject: string) {
  const key = subject.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
  if (key.includes('math') || key.includes('mathematique')) return colors.maths;
  if (key.includes('science') || key.includes('physique') || key.includes('chimie') || key.includes('svt')) return colors.sciences;
  if (key.includes('franc') || key.includes('francais')) return colors.francais;
  if (key.includes('hist') || key.includes('geo')) return colors.histoire;
  if (key.includes('angl') || key.includes('english')) return colors.anglais;
  return colors.default;
}

export const visualTypeColors: Record<string, string> = {
  title: 'linear-gradient(135deg, #0D1B2A 0%, #1B2838 100%)',
  content: 'linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)',
  example: 'linear-gradient(135deg, #1B4332 0%, #2D6A4F 100%)',
  formula: 'linear-gradient(135deg, #2D1B69 0%, #4A2C8A 100%)',
  summary: 'linear-gradient(135deg, #4A1942 0%, #6B1D5E 100%)',
};
